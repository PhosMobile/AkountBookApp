import 'package:akount_books/Api/BusinessPage/InvoiceItems.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Screens/BusinessPage/invoice_sent.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/currency_convert.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flushbar/flushbar.dart';

import '../../AppState/app_state.dart';

class SendInvoice extends StatefulWidget {
  @override
  _SendInvoiceState createState() => _SendInvoiceState();
}
class _SendInvoiceState extends State<SendInvoice> {
  InputStyles inputStyles = new InputStyles();
  bool sendViaEmail = true;
  bool sendViaWhatsApp = false;
  bool sendViaSMS = false;
  bool partPayment = true;
  bool fullPayment = false;
  String requestErrors;
  bool _isLoading = false;
  String flushBarTitle = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Send Invoice")),
        body: SingleChildScrollView(
          child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
                ),
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
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "Email Address",
                                          style: TextStyle(
                                            color: sendViaEmail
                                                ? Colors.white
                                                : Theme.of(context).primaryColor,
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
                                          ? sendViaWhatsappSelected
                                          : sendViaWhatsappUnselected,
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "WhatsApp",
                                          style: TextStyle(
                                            color: sendViaWhatsApp
                                                ? Colors.white
                                                : Theme.of(context).primaryColor,
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
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "SMS",
                                          style: TextStyle(
                                            color: sendViaSMS
                                                ? Colors.white
                                                : Theme.of(context).primaryColor,
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    state.invoiceCustomer.name,
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    state.readyInvoice.title,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(state.readyInvoice.summary),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(CurrencyConverter().formatPrice(
                                     state.readyInvoice.totalAmount,
                                      state.currentBusiness.currency)),
                                ),
                                width: MediaQuery.of(context).size.width,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 5,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CheckboxListTile(
                            title: Text("I have Received Part Payment",
                                style: TextStyle(color: Colors.grey[700])),
                            selected: partPayment,
                            checkColor: Colors.white,
                            value: partPayment,
                            onChanged: (value) {
                              setState(() {
                                partPayment = value;
                                fullPayment = false;
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          CheckboxListTile(
                            title: Text(
                              "I have Received Full Payment",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            selected: fullPayment,
                            checkColor: Colors.white,
                            value: fullPayment,
                            onChanged: (value) {
                              setState(() {
                                fullPayment = value;
                                partPayment = false;
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          PrimaryButton(
                            buttonText: _isLoading
                                ? LoaderLight()
                                : Text("SEND INVOICE",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                            onPressed: () {
                              _saveInvoiceName(context);
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

  void _saveInvoiceName(context) async {
    flushBarTitle = "Sending Invoice";
    Flushbar(
      title: flushBarTitle,
      message: "Your invoice is sending",
      duration: Duration(minutes: 3),
      showProgressIndicator: true,
      backgroundColor: Theme.of(context).primaryColor,
    )..show(context);
    final addInvoice = StoreProvider.of<AppState>(context);
    final invoiceData = StoreProvider.of<AppState>(context).state.readyInvoice;

    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createInvoice = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
        MutationOptions(
            document: createInvoice.createInvoice(
                invoiceData.title,
                invoiceData.number,
                invoiceData.poSoNumber,
                invoiceData.summary,
                invoiceData.issueDate,
                invoiceData.dueDate,
                invoiceData.subTotalAmount,
                invoiceData.totalAmount,
                invoiceData.notes,
                invoiceData.status,
                invoiceData.footer,
                invoiceData.customerId,
                invoiceData.businessId,
                invoiceData.userId)));
    if (!result.hasErrors) {
      String response = await InvoiceItems().saveInvoiceItems(
          addInvoice.state.invoiceItems, result.data["create_invoice"]["id"],context);
      dynamic invoiceQueryData = result.data["create_invoice"];
      if (response == "Done") {
        Invoice _invoice = new Invoice(
            invoiceQueryData["id"],
            invoiceQueryData["title"],
            invoiceQueryData["invoice_number"],
            invoiceQueryData["po_so_number"],
            invoiceQueryData["summary"],
            invoiceQueryData["issue_date"],
            invoiceQueryData["due_date"],
            invoiceQueryData["sub_total_amount"],
            invoiceQueryData["total_amount"],
            invoiceQueryData["notes"],
            invoiceQueryData["status"],
            invoiceQueryData["footer"],
            invoiceData.customerId,
            invoiceData.businessId,
            invoiceData.userId);
        addInvoice.dispatch(AddBusinessInvoice(payload: _invoice));
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InvoiceSent()),
        );
      } else {
        setState(() {
          flushBarTitle = response;
        });
        Navigator.of(context).pop();
      }
    } else {
      print(result.errors);
      Navigator.of(context).pop();
    }
  }

  final Widget sendViaWhatsappSelected = new SvgPicture.asset(
    SVGFiles.send_via_whatsApp_selected,
    semanticsLabel: 'send_via_whatsapp_selected',
    allowDrawingOutsideViewBox: true,
  );

  final Widget sendViaWhatsappUnselected = new SvgPicture.asset(
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
