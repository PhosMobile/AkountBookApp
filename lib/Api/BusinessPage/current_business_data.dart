import 'package:akount_books/AppState/actions/customer_actions.dart';
import 'package:akount_books/AppState/actions/expense_actions.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/AppState/actions/item_actions.dart';
import 'package:akount_books/AppState/actions/receipt_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Graphql/queries.dart';
import 'package:akount_books/Models/Expense.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Models/receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:akount_books/Graphql/graphql_config.dart';

class CurrentBusinessData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  dynamic getBusinessData(context, id) async {
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
    invoices.add(invoice);
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
    customers.add(customer);
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
        item["quantity"],
        item["price"],
        item["date"],
        item["business_id"],
        item["user_id"]);
    expenses.add(expense);
  }
  final saveExpense = StoreProvider.of<AppState>(context);
  saveExpense.dispatch(AddExpense(payload: expenses));
}
saveItems(context, data) {
  List<Item> businessItems = [];
  for (var item in data) {
    Item businessItem = Item(item["id"], item["name"], item["description"],
        item["quantity"], item["price"], item["business_id"], item["user_id"]);
    businessItems.add(businessItem);
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
        item["user_id"]);
    receipts.add(receipt);
  }
  final saveReceipt = StoreProvider.of<AppState>(context);
  saveReceipt.dispatch(AddReceipt(payload: receipts));
}
