import 'package:akaunt/Api/BusinessPage/record_payment.dart';
import 'package:akaunt/Api/BusinessPage/update_invoice.dart';
import 'package:akaunt/AppState/actions/invoice_actions.dart';
import 'package:akaunt/AppState/actions/item_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/edit_invoice.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/item.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/invoice_header.dart';
import 'package:akaunt/Widgets/view_invoice_field_card.dart';
import 'package:akaunt/dart.dart';
import 'package:akaunt/utilities/currency_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ViewInvoice extends StatelessWidget {
  final Invoice invoice;
  final Customer customer;
  final List<Item> invoiceItem;
  final String currency;

  ViewInvoice(
      {@required this.invoice,
      @required this.customer,
      @required this.invoiceItem,
      @required this.currency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Invoice Preview", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          actions: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  child: Text(
                    "DOWNLOAD",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onTap: () {
                    DownloadPdf().downloadPdf(context);
                  },
                ),
                InkWell(
                  child: Icon(MdiIcons.dotsVertical),
                  onTap: () {
                    EditInvoice _invoice = EditInvoice(
                        invoice.id,
                        invoice.title,
                        invoice.number,
                        invoice.poSoNumber,
                        invoice.summary,
                        invoice.issueDate,
                        invoice.dueDate,
                        invoice.subTotalAmount,
                        invoice.totalAmount,
                        invoice.notes,
                        invoice.status,
                        invoice.footer,
                        invoice.customerId,
                        invoice.businessId,
                        invoice.userId,
                        invoiceItem,
                        customer);

                    final editInvoice = StoreProvider.of<AppState>(context);
                    editInvoice.dispatch(AddEditInvoice(payload: _invoice));
                    editInvoice
                        .dispatch(EditInvoiceItems(payload: invoiceItem));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateInvoiceData()),
                    );
                  },
                )
              ],
            )
          ],
        ),
        body: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(
                              width: 2, color: Theme.of(context).accentColor))),
                  child: new Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            // has the effect of softening the shadow
                            spreadRadius: 1.0,
                            // has the effect of extending the shadow
                            offset: Offset(
                              0.0, // horizontal, move right 10
                              0.0, // vertical, move down 10
                            ),
                          )
                        ], color: Colors.white),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InvoiceHeader(status: invoice.status),
                            Divider(
                              thickness: 2,
                              color: Theme.of(context).accentColor,
                              height: 30,
                            ),
                            ViewInvoiceFieldCard(
                                title: "Invoice Name:", value: invoice.title),
                            ViewInvoiceFieldCard(
                                title: "Invoice Date:",
                                value: invoice.issueDate),
                            ViewInvoiceFieldCard(
                                title: "Due Date:", value: invoice.dueDate),
                            ViewInvoiceFieldCard(
                                title: "Amount Due",
                                value: CurrencyConverter()
                                    .formatPrice(invoice.totalAmount, "NGN")),
                            ViewInvoiceFieldCard(
                                title: "Customer Name:", value: customer.name),

                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 5, right: 5),
                              color: Theme.of(context).accentColor,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      child: Text("ITEMS"),
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          30),
                                  Container(
                                      child: Text("QTY "),
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          30),
                                  Text("AMOUNT"),
                                ],
                              ),
                            ),
                            for (var item in invoiceItem)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text("${item.name}"),
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          30,
                                    ),
                                    Container(
                                        child: Text("${item.quantity}"),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    3 -
                                                30),
                                    Text(CurrencyConverter().formatPrice(
                                        int.parse(item.price),
                                        state.currentBusiness.currency)),
                                  ],
                                ),
                              ),

                            SizedBox(
                              height: 30,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color: Theme.of(context)
                                                .accentColor))),
                                padding: EdgeInsets.only(top: 10, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Tax"),
                                    Text("N 3,000"),
                                  ],
                                )),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color:
                                              Theme.of(context).accentColor))),
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Total"),
                                  Text(CurrencyConverter().formatPrice(
                                      invoice.totalAmount,
                                      state.currentBusiness.currency)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color:
                                              Theme.of(context).accentColor))),
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text("NOTES"),
                                  Text("${invoice.notes}"),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("FOOTER"),
                                  Text("${invoice.footer}"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                PrimaryMiniButton(
                                  buttonText: Text("SEND REMINDER",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 14,
                                          color: Colors.white)),
                                  onPressed: () {},
                                ),
                                SecondaryMiniButton(
                                  buttonText: Text("SEND RECEIPT",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 14,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  onPressed: () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(
                                            CreateInvoice(payload: invoice));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecordPayment()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
