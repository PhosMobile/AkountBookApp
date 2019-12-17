import 'package:akaunt/Api/BusinessPage/get_invoice_items.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/item.dart';
import 'package:akaunt/Screens/BusinessPage/view_invoice.dart';
import 'package:akaunt/Screens/BusinessPage/view_invoice_draft.dart';
import 'package:akaunt/Widgets/invoice_status.dart';
import 'package:akaunt/Widgets/loading_snack_bar.dart';
import 'package:akaunt/utilities/currency_convert.dart';
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
                      invoices[index].customerId, customers);
                  if (invoiceCustomer != null) {
                    cName = invoiceCustomer.name;
                  }
                  String invoiceTitle = invoices[index].title;
                  Invoice invoice = invoices[index];
                  return InkWell(
                    child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(250, 253, 255, 1),
                            border: Border(
                                bottom: BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(198, 228, 255, 1)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                invoice.status.toLowerCase() == "due"
                                    ? InvoiceStatus(
                                        status: invoice.status,
                                        avatarBgColor:
                                            Color.fromRGBO(251, 224, 192, 1),
                                        textColor:
                                            Color.fromRGBO(88, 52, 4, 1),
                                      )
                                    : SizedBox(),
                                invoice.status.toLowerCase() == "draft"
                                    ? InvoiceStatus(
                                        status: invoice.status,
                                        avatarBgColor:
                                            Color.fromRGBO(224, 237, 253, 1),
                                        textColor:
                                            Color.fromRGBO(68, 130, 193, 1))
                                    : SizedBox(),
                                invoice.status.toLowerCase() == "paid"
                                    ? InvoiceStatus(
                                        status: invoice.status,
                                        avatarBgColor:
                                            Color.fromRGBO(192, 251, 221, 1),
                                        textColor:
                                            Color.fromRGBO(4, 88, 38, 1))
                                    : SizedBox(),
                                invoice.status.toLowerCase() == "sent"
                                    ? InvoiceStatus(
                                    status: invoice.status,
                                    avatarBgColor:
                                    Color.fromRGBO(224, 237, 253, 1),
                                    textColor:
                                    Color.fromRGBO(68, 130, 193, 1))
                                    : SizedBox(),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "$cName",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "$invoiceTitle",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromRGBO(106, 117, 139, 1)),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                    CurrencyConverter().formatPrice(
                                        invoice.totalAmount, currency),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(invoice.dueDate,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            Color.fromRGBO(106, 117, 139, 1)))
                              ],
                            )
                          ],
                        )),
                    onTap: () async {
                      List<Item> allInvoiceItems = [];
                      _scaffoldKey.currentState.showSnackBar(LoadingSnackBar()
                          .loaderHigh("  Getting Invoice Data...", context));
                      List<dynamic> invoiceItems = await GetInvoiceItems()
                          .fetchInvoiceItems(invoice.id, context);
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
                            builder: (context) => draft
                                ? ViewInvoiceDraft(
                                    invoice: invoice,
                                    customer: invoiceCustomer,
                                    invoiceItem: allInvoiceItems,
                                    currency: currency)
                                : ViewInvoice(
                                    invoice: invoice,
                                    customer: invoiceCustomer,
                                    invoiceItem: allInvoiceItems,
                                    currency: currency)),
                      );
                    },
                  );
                });
          }),
    );
  }
}
