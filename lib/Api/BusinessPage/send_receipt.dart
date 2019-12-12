import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/receipt.dart';
import 'package:akount_books/Screens/BusinessPage/receipt_sent.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/currency_convert.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SendReceipt extends StatefulWidget {
  @override
  _SendReceiptState createState() => _SendReceiptState();
}

class _SendReceiptState extends State<SendReceipt> {
  InputStyles inputStyles = new InputStyles();
  bool sendViaEmail = true;
  bool sendViaWhatsApp = false;
  bool sendViaSMS = false;
  bool partPayment = true;
  bool fullPayment = false;
  String requestErrors;
  String flushBarTitle = "";
  int receivedPayment = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Send Receipt")),
        body: SingleChildScrollView(
          child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              Invoice invoice = state.readyInvoice;
              Receipt receipt = state.invoiceReceipt;
              Customer customer = state.invoiceCustomer;
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 2, color: Theme.of(context).accentColor))),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 18.0, bottom: 28.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Send via (select means of  sending invoice",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: sendViaEmail
                                          ? inputStyles.setSendSelected(context)
                                          : inputStyles.setSendUnSelected(context),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          sendViaEmail
                                              ? sendViaEmailSelected
                                              : sendViaEmailUnselected,
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 10.0),
                                            child: Text(
                                              "Email Address",
                                              style: TextStyle(
                                                color: sendViaEmail
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 11.5,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        sendViaSMS = false;
                                        sendViaEmail = true;
                                        sendViaWhatsApp = false;
                                      });
                                    },
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: sendViaWhatsApp
                                          ? inputStyles.setSendSelected(context)
                                          : inputStyles.setSendUnSelected(context),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          sendViaWhatsApp
                                              ? sendViaWhatsAppSelected
                                              : sendViaWhatsAppUnselected,
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 10.0),
                                            child: Text(
                                              "WhatsApp",
                                              style: TextStyle(
                                                color: sendViaWhatsApp
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 11.5,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        sendViaSMS = false;
                                        sendViaEmail = false;
                                        sendViaWhatsApp = true;
                                      });
                                    },
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: sendViaSMS
                                          ? inputStyles.setSendSelected(context)
                                          : inputStyles.setSendUnSelected(context),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          sendViaSMS
                                              ? sendViaSmsSelected
                                              : sendViaSmsUnselected,
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 10.0),
                                            child: Text(
                                              "SMS",
                                              style: TextStyle(
                                                color: sendViaSMS
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 11.5,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        sendViaSMS = true;
                                        sendViaEmail = false;
                                        sendViaWhatsApp = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:20.0),
                                      child: Text(
                                       "Hi, ${state.invoiceCustomer.name}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:20.0, top: 5, bottom: 5),
                                      child: Text(
                                        "here's the payment of receipt  for the total amount of \n ${CurrencyConverter().formatPrice(int.parse(state.invoiceReceipt.amountPaid), state.currentBusiness.currency)}",
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ],
                              ),

                              state.invoiceReceipt != null
                                  ? Card(
                                child: ListTile(
                                  title: Text(
                                    "${state.invoiceReceipt.paymentType} Payment of ${CurrencyConverter().formatPrice(int.parse(state.invoiceReceipt.amountPaid), state.currentBusiness.currency)}",
                                    textAlign: TextAlign.left,
                                  ),
                                  subtitle: Text(
                                    "Balance ${CurrencyConverter().formatPrice(state.readyInvoice.totalAmount - int.parse(state.invoiceReceipt.amountPaid), state.currentBusiness.currency)}",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                color: Colors.white,
                                clipBehavior: Clip.none,
                              )
                                  : Container(),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(height: 20,),
                              PrimaryButton(
                                buttonText: Text("SEND RECEIPT",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 14,
                                        color: Colors.white)),
                                onPressed: () {
                                      _sendReceipt(context,receipt,customer,invoice);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  _sendReceipt(context, Receipt receipt, Customer customer, Invoice invoice){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => ReceiptSent(customer:customer)),
    );
  }
  final Widget sendViaWhatsAppSelected = new SvgPicture.asset(
    SVGFiles.send_via_whatsApp_selected,
    semanticsLabel: 'send_via_whatsapp_selected',
    allowDrawingOutsideViewBox: true,
  );

  final Widget sendViaWhatsAppUnselected = new SvgPicture.asset(
    SVGFiles.send_via_whatsApp_unselected,
    semanticsLabel: 'send_via_whatsapp_unselected',
    allowDrawingOutsideViewBox: true,
  );

  final Widget sendViaEmailSelected = new SvgPicture.asset(
    SVGFiles.send_via_email_selected,
    semanticsLabel: 'send_via_email_selected',
    allowDrawingOutsideViewBox: true,
  );
  final Widget sendViaEmailUnselected = new SvgPicture.asset(
    SVGFiles.send_via_email_unselected,
    semanticsLabel: 'send_via_email_unselected',
    allowDrawingOutsideViewBox: true,
  );
  final Widget sendViaSmsSelected = new SvgPicture.asset(
    SVGFiles.send_via_sms_selected,
    semanticsLabel: 'send_via_sms_selected',
    allowDrawingOutsideViewBox: true,
  );
  final Widget sendViaSmsUnselected = new SvgPicture.asset(
    SVGFiles.send_via_sms_unselected,
    semanticsLabel: 'send_via_sms_unselected',
    allowDrawingOutsideViewBox: true,
  );
}
