import 'package:akaunt/Api/BusinessPage/update_draft.dart';
import 'package:akaunt/AppState/actions/invoice_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/discount.dart';
import 'package:akaunt/Models/edit_invoice.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/item.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/invoice_header.dart';
import 'package:akaunt/Widgets/view_invoice_field_card.dart';
import 'package:akaunt/utilities/currency_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ViewInvoiceDraft extends StatelessWidget {
  final Invoice invoice;
  final Customer customer;
  final List<Item> invoiceItem;
  final String currency;
  final List<Discount> discounts;
  final List<Receipt> receipts;

  ViewInvoiceDraft(
      {@required this.invoice,
      @required this.customer,
      @required this.invoiceItem,
      @required this.currency,
      @required this.discounts,
      @required this.receipts});

  @override
  Widget build(BuildContext context) {
    double _amountPaid = Receipt.calculateTotalAmount(receipts);
    double _invoiceBalance = Invoice.calculateInvoiceBalance(
        receipts, invoice.totalAmount);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Draft Preview", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          actions: <Widget>[
            InkWell(
              child: Icon(MdiIcons.dotsVertical),
              onTap: () {
                editAndSendDraft(context);
              },
            )
          ],
        ),
        body: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
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
                        padding: EdgeInsets.all(10),
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
                            discounts.length > 0
                                ? Column(
                              children: <Widget>[
                                Divider(
                                  thickness: 1,
                                  color: Theme.of(context).accentColor,
                                  height: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  width:
                                  MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Discounts/Tax",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                for (var discount in discounts)
                                  Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      padding: EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Text(discount.dType == 1
                                              ? "Taxed"
                                              : "Discount of"),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                4 +
                                                50,
                                            child: Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                discount.description,
                                                style: TextStyle(
                                                    color: Theme.of(
                                                        context)
                                                        .primaryColor),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Text(CurrencyConverter()
                                              .formatPrice(
                                              double.parse(
                                                  discount.amount),
                                              state.currentBusiness
                                                  .currency)),
                                        ],
                                      )),
                                Divider(
                                  thickness: 1,
                                  color: Theme.of(context).accentColor,
                                  height: 30,
                                ),
                              ],
                            )
                                : SizedBox(),
                            discounts.length > 0
                                ? Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  width:
                                  MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Receipts",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                for (var receipt in receipts)
                                  Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      padding: EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Text(receipt.paymentDate),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                4 +
                                                50,
                                            child: Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                receipt.name,
                                                style: TextStyle(
                                                    color: Theme.of(
                                                        context)
                                                        .primaryColor),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Text(CurrencyConverter()
                                              .formatPrice(
                                              double.parse(
                                                  receipt.amountPaid),
                                              state.currentBusiness
                                                  .currency)),
                                        ],
                                      )),
                                Divider(
                                  thickness: 1,
                                  color: Theme.of(context).accentColor,
                                  height: 30,
                                ),
                              ],
                            )
                                : SizedBox(),
                            ViewInvoiceFieldCardBold(
                                title: "Total:",
                                value: CurrencyConverter().formatPrice(
                                    invoice.totalAmount,
                                    state.currentBusiness.currency)),
                            ViewInvoiceFieldCardBold(
                                title: "Amount Paid:",
                                value: CurrencyConverter().formatPrice(
                                    _amountPaid,
                                    state.currentBusiness.currency)),
                            ViewInvoiceFieldCardBold(
                                title: "Balance:",
                                value: CurrencyConverter().formatPrice(
                                    _invoiceBalance,
                                    state.currentBusiness.currency)),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          width: 2,
                                          color:
                                          Theme.of(context).accentColor))),
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text("NOTES"),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text("${invoice.notes}"),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("${invoice.footer}"),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                PrimaryButton(
                                  buttonText: Text("SEND DRAFT ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 14,
                                          color: Colors.white)),
                                  onPressed: () {
                                    editAndSendDraft(context);
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

  editAndSendDraft(context) {
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateDraft()),
    );
  }
}
