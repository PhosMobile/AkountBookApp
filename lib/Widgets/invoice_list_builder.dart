import 'package:akount_books/Api/BusinessPage/get_invoice_items.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Screens/BusinessPage/view_invoice.dart';
import 'package:akount_books/Screens/BusinessPage/view_invoice_draft.dart';
import 'package:akount_books/Widgets/loading_snack_bar.dart';
import 'package:akount_books/utilities/currency_convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InvoiceListBuilder extends StatelessWidget {
  final List<Invoice> invoices;
  final bool draft;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  InvoiceListBuilder({@required this.invoices, @required this.draft});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            List<Customer> customers = state.businessCustomers;
            String currency = state.currentBusiness.currency;
            return ListView.builder(
                itemCount: invoices.length,
                itemBuilder: (BuildContext context, int index) {
                  String cName;
                  Customer invoiceCustomer = Invoice.getInvoiceCustomer(
                      invoices[index].customer_id, customers);
                  if(invoiceCustomer != null){
                    cName = invoiceCustomer.name;
                  }
                  String invoiceTitle = invoices[index].title;
                  Invoice invoice = invoices[index];
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(248, 248, 248, 1),
                          border: Border(
                              bottom: BorderSide(
                                  width: 2,
                                  color: Color.fromRGBO(233, 237, 240, 1)))),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("$invoiceTitle > $cName"),
                              Text(
                                CurrencyConverter().formatPrice(
                                    invoice.total_amount, currency),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                child: Text(
                                  invoice.status,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              Text(invoice.due_date)
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      List<Item> allInvoiceItems = [];
                      _scaffoldKey.currentState.showSnackBar(
                      LoadingSnackBar().loader("  Getting Invoice Data...", context));
                      List<dynamic> invoiceItems =
                          await GetInvoiceItems().fetchInvoiceItems(invoice.id,context);
                      if (invoiceItems == null) {
                      } else {
                        for (var item in invoiceItems) {
                          state.businessItems.forEach((businessItem) {
                            if (item["item_id"] == businessItem.id) {
                              allInvoiceItems.add(businessItem);
                            }
                          });
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => draft?ViewInvoiceDraft(invoice: invoice,
                                customer: invoiceCustomer,
                                invoiceItem: allInvoiceItems,
                                currency:currency):ViewInvoice(
                                invoice: invoice,
                                customer: invoiceCustomer,
                                invoiceItem: allInvoiceItems,
                                currency:currency
                            )),
                      );
                    },
                  );
                });
          }),
    );
  }
}
