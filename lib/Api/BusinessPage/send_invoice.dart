import 'package:akaunt/Api/BusinessPage/invoice_discount.dart';
import 'package:akaunt/Api/BusinessPage/invoice_items.dart';
import 'package:akaunt/Api/BusinessPage/create_receipt.dart';
import 'package:akaunt/AppState/actions/invoice_actions.dart';
import 'package:akaunt/AppState/actions/receipt_actions.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:akaunt/Service/invoice_service.dart';
import 'package:akaunt/Widgets/AlertSnackBar.dart';
import 'package:akaunt/Widgets/HeaderTitle.dart';
import 'package:akaunt/Widgets/loader_widget.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/utilities/currency_convert.dart';
import 'package:akaunt/utilities/invoice_pdf.dart';
import 'package:akaunt/utilities/invoice_to_pdf.dart';
import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:akaunt/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:email_validator/email_validator.dart';

import '../../AppState/app_state.dart';

class SendInvoice extends StatefulWidget {
  @override
  _SendInvoiceState createState() => _SendInvoiceState();
}

class _SendInvoiceState extends State<SendInvoice> {
  InputStyles inputStyles = new InputStyles();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  bool sendViaEmail = true;
  bool sendViaWhatsApp = false;
  bool sendViaSMS = false;
  bool partPayment = true;
  bool fullPayment = false;
  String requestErrors;
  bool _isLoading = false;
  Invoice pInvoice;
  List<Receipt> _receipt;
  String flushBarTitle = "";
  int receivedPayment = 0;
  AlertSnackBar alert = AlertSnackBar();
  bool pdfCreated= false;
  String pdfPath = "";

  @override
  Widget build(BuildContext context) {

    final state = StoreProvider.of<AppState>(context).state;
    if(state.invoiceReceipt != null){
      if(double.parse(state.invoiceReceipt.amountPaid) >= state.readyInvoice.totalAmount ){
        setState(() {
          receivedPayment = 2;
        });
      }else{
        setState(() {
          receivedPayment = 1;
        });
      }
    }else{
      setState(() {
        receivedPayment = 0;
      });
    }
    return new Scaffold(
        key: _scaffoldState,
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
                                "Send via (select means of  sending invoice)",
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
                                  padding: const EdgeInsets.only(left: 20.0),
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
                                  padding: const EdgeInsets.only(left: 20.0),
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
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(state.readyInvoice.summary),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(CurrencyConverter().formatPrice(
                                      state.readyInvoice.totalAmount,
                                      state.currentBusiness.currency)),
                                ),
                                width: MediaQuery.of(context).size.width,
                              )
                            ],
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          state.invoiceReceipt != null
                              ? Card(
                                  child: ListTile(
                                    trailing: InkWell(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                        size: 16,
                                      ),
                                      onTap: () {
                                        deleteInvoiceReceipt(context);
                                      },
                                    ),
                                    title: Text(
                                      "${state.invoiceReceipt.paymentType} Payment of ${CurrencyConverter().formatPrice(double.parse(state.invoiceReceipt.amountPaid), state.currentBusiness.currency)}",
                                      textAlign: TextAlign.left,
                                    ),
                                    subtitle: Text(
                                      "Balance ${CurrencyConverter().formatPrice(state.readyInvoice.totalAmount - double.parse(state.invoiceReceipt.amountPaid), state.currentBusiness.currency)}",
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
                          InkWell(
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child:
                                          Text("I have Received Part Payment")),
                                  Radio(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: 1,
                                      groupValue: receivedPayment,
                                      onChanged: (e) {
                                        if (receivedPayment != 1) {
                                          setState(() {
                                            receivedPayment = 1;
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddReceipt()),
                                          );
                                        } else {
                                          setState(() {
                                            receivedPayment = 0;
                                          });
                                        }
                                      })
                                ],
                              ),
                            ),
                            onTap: () {
                              if (receivedPayment != 1) {
                                setState(() {
                                  receivedPayment = 1;
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddReceipt()),
                                );
                              } else {
                                setState(() {
                                  receivedPayment = 0;
                                });
                              }
                            },
                          ),
                          InkWell(
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child:
                                          Text("I have Received Full Payment")),
                                  Radio(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: 2,
                                      groupValue: receivedPayment,
                                      onChanged: (e) {
                                        if (receivedPayment != 1) {
                                          setState(() {
                                            receivedPayment = 1;
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddReceipt()),
                                          );
                                        } else {
                                          setState(() {
                                            receivedPayment = 0;
                                          });
                                        }
                                      })
                                ],
                              ),
                            ),
                            onTap: () {
                              if (receivedPayment != 2) {
                                setState(() {
                                  receivedPayment = 2;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddReceipt(
                                            invoicePrice: state
                                                .readyInvoice.totalAmount
                                                .toInt(),
                                          )),
                                );
                              } else {
                                setState(() {
                                  receivedPayment = 0;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          PrimaryButton(
                            buttonText: _isLoading
                                ? LoaderLight()
                                : Text("SEND INVOICE",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                            onPressed: () {
                              _prepareInvoice(context, "SEND");
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SecondaryButton(
                            buttonText: _isLoading
                                ? LoaderLight()
                                : Text("SAVE & PREVIEW",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor)),
                            onPressed: () {
                              _prepareInvoice(context, "PREVIEW");
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

  void _prepareInvoice(context, action) async {
    final addInvoice = StoreProvider.of<AppState>(context);
    String sendVia;
    if (sendViaWhatsApp) {
      sendVia = "WhatsApp";
    } else if (sendViaEmail) {
      if (!EmailValidator.validate(addInvoice.state.invoiceCustomer.email) ||
          addInvoice.state.invoiceCustomer.email == null ||
          addInvoice.state.invoiceCustomer.email == "null") {
        _scaffoldState.currentState.showSnackBar(alert.showSnackBar(
            "Customer email is invalid or does not exist please sellect another means of send invoice or update customer info"));
        return;
      } else {
        sendVia = "Email";
      }
    } else {
      sendVia = "SMS";
    }


    if (pdfCreated) {
      _sendInvoice(sendVia,action);
    } else {


    final invoiceData = StoreProvider
        .of<AppState>(context)
        .state
        .readyInvoice;

    flushBarTitle = "Creating Invoice";
    Flushbar(
      title: flushBarTitle,
      message: "invoice is getting ready to send",
      duration: Duration(minutes: 3),
      showProgressIndicator: true,
      backgroundColor: Theme
          .of(context)
          .primaryColor,
    )
      ..show(context);

    final receiptData =
        StoreProvider
            .of<AppState>(context)
            .state
            .invoiceReceipt;

    List<Receipt> receipts = [];

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
      String invoiceItemResponse = await InvoiceItems().saveInvoiceItems(
          addInvoice.state.invoiceItems,
          result.data["create_invoice"]["id"],
          context);

      if (invoiceItemResponse == "Done") {
        String response = await InvoiceDiscounts().saveInvoiceDiscounts(
            addInvoice.state.invoiceDiscount,
            result.data["create_invoice"]["id"],
            context);
        dynamic invoiceQueryData = result.data["create_invoice"];

        if (response == "Done") {
          if (receiptData != null) {
            Mutations createReceipt = new Mutations();
            QueryResult receiptResult = await graphQLConfiguration
                .getGraphql(context)
                .mutate(MutationOptions(
                document: createReceipt.createReceipt(
                    addInvoice.state.invoiceName.title + "001",
                    int.parse(receiptData.amountPaid),
                    receiptData.paymentDate,
                    receiptData.paymentMethod,
                    receiptData.paymentType,
                    "done",
                    invoiceQueryData["id"],
                    invoiceData.businessId,
                    invoiceData.customerId,
                    invoiceData.userId)));
            if (receiptResult.hasErrors) {
              print(receiptResult.errors);
            } else {
              dynamic receiptData = receiptResult.data["create_receipt"];
              Receipt _receipt = new Receipt(
                  receiptData["id"],
                  receiptData["name"],
                  receiptData["amount_paid"],
                  receiptData["payment_date"],
                  receiptData["payment_method"],
                  receiptData["payment_type"],
                  receiptData["status"],
                  receiptData["invoice_id"],
                  receiptData["business_id"],
                  receiptData["customer_id"],
                  receiptData["user_id"]);
              receipts.add(_receipt);
              addInvoice.dispatch(UpdateBusinessReceipt(payload: _receipt));
            }
          }
          Invoice _invoice = new Invoice(
              invoiceQueryData["id"],
              invoiceQueryData["title"],
              invoiceQueryData["invoice_number"],
              invoiceQueryData["po_so_number"],
              invoiceQueryData["summary"],
              invoiceQueryData["issue_date"],
              invoiceQueryData["due_date"],
              invoiceQueryData["sub_total_amount"].toDouble(),
              invoiceQueryData["total_amount"].toDouble(),
              invoiceQueryData["notes"],
              invoiceQueryData["status"],
              invoiceQueryData["footer"],
              invoiceData.customerId,
              invoiceData.businessId,
              invoiceData.userId);

          addInvoice.dispatch(AddBusinessInvoice(payload: _invoice));
          setState(() {
            pInvoice = _invoice;
            _receipt = receipts;
          });
          Navigator.of(context).pop();

          _sendInvoice(sendVia,action);

        } else {
          setState(() {
            flushBarTitle = response;
          });
        }
      }
    } else {
      print(result.errors);
      Navigator.of(context).pop();
    }
  }
  }

  deleteInvoiceReceipt(context) {
    final removeInvoice = StoreProvider.of<AppState>(context);
    removeInvoice.dispatch(
        DeleteInvoiceReceipt(payload: removeInvoice.state.invoiceReceipt));
    setState(() {
      receivedPayment = 0;
    });
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



  _sendInvoice(sendVia,action) async{
    final store = StoreProvider.of<AppState>(context);
    if(pdfCreated){

    }else{
      String path = await InvoiceToPdf(
        invoice: pInvoice,
        currentBusiness: store.state.currentBusiness,
        customer: store.state.invoiceCustomer,
        invoiceItem: store.state.invoiceItems,
        receipts: _receipt,
      ).downloadPdf(context);
      setState(() {
        pdfPath = path;
        pdfCreated = true;
      });
    }
    if(action == "SEND"){
      flushBarTitle = "Sending Invoice";
      Flushbar(
        title: flushBarTitle,
        message: "invoice is sending",
        duration: Duration(minutes: 3),
        showProgressIndicator: true,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      )
        ..show(context);

      if (sendVia == "Email") {
        await InvoiceService().sendViaEmail(pInvoice, store.state.invoiceCustomer, pdfPath,context);

      } else if (sendVia == "SMS") {
        InvoiceService().sendViaSMS(pInvoice, store.state.invoiceCustomer, pdfPath,context);
      } else {
        InvoiceService().sendViaWhatsApp(pInvoice, store.state.invoiceCustomer, pdfPath,context);
      }
    }else{
      Navigator.of(context).push(MaterialPageRoute(

          builder: (_) => InvoicePDF(
            path: pdfPath,
            customer: store.state.invoiceCustomer,
            invoice: pInvoice,
            sendVia: sendVia,
          )));
    }
  }

}

