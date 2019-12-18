import 'package:akaunt/AppState/actions/customer_actions.dart';
import 'package:akaunt/AppState/actions/expense_actions.dart';
import 'package:akaunt/AppState/actions/invoice_actions.dart';
import 'package:akaunt/AppState/actions/item_actions.dart';
import 'package:akaunt/AppState/actions/receipt_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Graphql/queries.dart';
import 'package:akaunt/Models/Expense.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/item.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:akaunt/Screens/BusinessPage/fetch_user_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:akaunt/Graphql/graphql_config.dart';

class CurrentBusinessData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  dynamic getBusinessData(context, id) async {
    if(StoreProvider.of<AppState>(context).state.userContacts.length == 0){
      await FetchUserData().fetchContacts(context);
    }
    GqlConfig graphQLConfiguration = GqlConfig();
    Queries queries = Queries();
    QueryResult result = await graphQLConfiguration.getGraphql(context).query(
          QueryOptions(
              document: queries.getCurrentBusinessData, variables: {"id": id}),
        );
    if (!result.hasErrors) {
      var customers = result.data["get_business"]["customers"];
      var items = result.data["get_business"]["items"];
      var invoices = result.data["get_business"]["invoices"];
      var expenses = result.data["get_business"]["expenses"];
      var receipts = result.data["get_business"]["receipts"];
      saveInvoices(context, invoices);
      saveCustomers(context, customers);
      saveExpenses(context, expenses);
      saveItems(context, items);
      saveReceipts(context, receipts);
      Navigator.pop(context);
    } else {
      print(result.errors);
      print(result.source);
    }
  }
}
saveInvoices(context, data) {
  List<Invoice> invoices = [];
  for (var item in data) {
    Invoice invoice = Invoice(
        item["id"],
        item["title"],
        item["number"],
        item["po_so_number"],
        item["summary"],
        item["issue_date"],
        item["due_date"],
        item["sub_total_amount"],
        item["total_amount"],
        item["notes"],
        item["status"],
        item["footer"],
        item["customer_id"],
        item["business_id"],
        item["user_id"],

    );
    invoices.insert(0,invoice);
  }
  final saveInvoice = StoreProvider.of<AppState>(context);
  saveInvoice.dispatch(FetchUserInvoice(payload: invoices));
}

saveCustomers(context, data) {
  List<Customer> customers = [];
  for (var item in data) {
    Customer customer = Customer(
        item["id"],
        item["name"],
        item["email"],
        item["phone"],
        item["address"],
        item["currency"],
        item["image_url"],
        item["business_id"],
        item["user_id"]);
    customers.insert(0, customer);
  }
  final saveCustomer = StoreProvider.of<AppState>(context);
  saveCustomer.dispatch(AddCustomer(payload: customers));
}
saveExpenses(context, data) {
  List<Expense> expenses = [];
  for (var item in data) {
    Expense expense = Expense(
        item["id"],
        item["name"],
        item["description"],
        int.parse(item["quantity"]),
        item["price"],
        item["date"],
        item["business_id"],
        item["user_id"]);
    expenses.insert(0,expense);
  }
  final saveExpense = StoreProvider.of<AppState>(context);
  saveExpense.dispatch(AddExpense(payload: expenses));
}

saveItems(context, data) {
  List<Item> businessItems = [];
  for (var item in data) {
    Item businessItem = Item(item["id"], item["name"], item["description"],
        item["quantity"], item["price"], item["business_id"], item["user_id"]);
    businessItems.insert(0,businessItem);
  }
  final saveItem = StoreProvider.of<AppState>(context);
  saveItem.dispatch(AddBusinessItem(payload: businessItems));
}

saveReceipts(context, data){
  List<Receipt> receipts = [];
  for (var item in data) {
    Receipt receipt = Receipt(
        item["id"],
        item["name"],
        item["amount_paid"],
        item["payment_date"],
        item["payment_method"],
        item["payment_type"],
        item["status"],
        item["invoice_id"],
        item["business_id"],
        item["customerId"],
        item["user_id"]);
    receipts.insert(0,receipt);
  }
  final saveReceipt = StoreProvider.of<AppState>(context);
  saveReceipt.dispatch(AddBusinessReceipt(payload: receipts));
}
