import 'package:akaunt/Api/BusinessPage/record_payment.dart';
import 'package:akaunt/Api/BusinessPage/update_invoice.dart';
import 'package:akaunt/AppState/actions/customer_actions.dart';
import 'package:akaunt/AppState/actions/invoice_actions.dart';
import 'package:akaunt/AppState/actions/item_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/business.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/discount.dart';
import 'package:akaunt/Models/edit_invoice.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/item.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/invoice_header.dart';
import 'package:akaunt/Widgets/loading_snack_bar.dart';
import 'package:akaunt/Widgets/view_invoice_field_card.dart';
import 'package:akaunt/utilities/invoice_to_pdf.dart';
import 'package:akaunt/utilities/currency_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// ignore: must_be_immutable
class ViewInvoice extends StatefulWidget {
  final Invoice invoice;
  final Customer customer;
  final List<Item> invoiceItem;
  final String currency;
  final List<Discount> discounts;
  final List<Receipt> receipts;

  Business currentBusiness;

  ViewInvoice(
      {@required this.invoice,
      @required this.customer,
      @required this.invoiceItem,
      @required this.currency,
      @required this.discounts,
      @required this.receipts});

  @override
  _ViewInvoiceState createState() => _ViewInvoiceState();
}

class _ViewInvoiceState extends State<ViewInvoice> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double _amountPaid = Receipt.calculateTotalAmount(widget.receipts);
    double _invoiceBalance = Invoice.calculateInvoiceBalance(
        widget.receipts, widget.invoice.totalAmount);
    return Scaffold(
        key: _scaffoldKey,
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
                    generateInvoicePdf();
                  },
                ),
                InkWell(
                  child: Icon(MdiIcons.dotsVertical),
                  onTap: () {
                    Invoice invoice = widget.invoice;
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
                        widget.invoiceItem,
                        widget.customer);

                    final editInvoice = StoreProvider.of<AppState>(context);
                    editInvoice.dispatch(AddEditInvoice(payload: _invoice));
                    editInvoice.dispatch(
                        EditInvoiceItems(payload: widget.invoiceItem));
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
            onInitialBuild: (state) {
              setState(() {
                widget.currentBusiness = state.currentBusiness;
              });
            },
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
                            InvoiceHeader(status: widget.invoice.status),
                            Divider(
                              thickness: 2,
                              color: Theme.of(context).accentColor,
                              height: 30,
                            ),
                            ViewInvoiceFieldCard(
                                title: "Invoice Name:",
                                value: widget.invoice.title),
                            ViewInvoiceFieldCard(
                                title: "Invoice Date:",
                                value: widget.invoice.issueDate),
                            ViewInvoiceFieldCard(
                                title: "Due Date:",
                                value: widget.invoice.dueDate),
                            ViewInvoiceFieldCard(
                                title: "Amount Due",
                                value: CurrencyConverter().formatPrice(
                                    widget.invoice.totalAmount, "NGN")),
                            ViewInvoiceFieldCard(
                                title: "Customer Name:",
                                value: widget.customer.name),
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
                                      child: Text("QTY"),
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          30),
                                  Text("AMOUNT"),
                                ],
                              ),
                            ),
                            for (var item in widget.invoiceItem)
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
                            widget.discounts.length > 0
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
                                      for (var discount in widget.discounts)
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
                            widget.discounts.length > 0
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
                                      for (var receipt in widget.receipts)
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
                                    widget.invoice.totalAmount,
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
                                  Text("${widget.invoice.notes}"),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("${widget.invoice.footer}"),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            _invoiceBalance > 0 ? Row(
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
                                        .dispatch(CreateInvoice(
                                            payload: widget.invoice));
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(AddInvoiceCustomer(
                                        payload: widget.customer));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecordPayment()),
                                    );
                                  },
                                ),
                              ],
                            ):PrimaryButton(
                              buttonText: Text("BACK",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 14,
                                      color: Colors.white)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
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
  generateInvoicePdf() async {
    _scaffoldKey.currentState.showSnackBar(
        LoadingSnackBar().loaderHigh("Preparing Invoice...", context));
    List<Receipt> receipts = [];
    final store = StoreProvider.of<AppState>(context);
    store.state.businessReceipts.forEach((receipt) {
      if (receipt.invoiceId == widget.invoice.id) {
        receipts.add(receipt);
      }
    });

    await InvoiceToPdf(
            invoice: widget.invoice,
            currentBusiness: widget.currentBusiness,
            customer: widget.customer,
            invoiceItem: widget.invoiceItem,
            receipts: receipts)
        .downloadPdf(context);
  }
}
