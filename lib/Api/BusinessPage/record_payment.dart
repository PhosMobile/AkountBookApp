import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:akaunt/Screens/BusinessPage/preview_receipt.dart';
import 'package:akaunt/Screens/invoice_list.dart';
import 'package:akaunt/Widgets/AlertSnackBar.dart';
import 'package:akaunt/Widgets/HeaderTitle.dart';
import 'package:akaunt/Widgets/loader_widget.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akaunt/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';

class RecordPayment extends StatefulWidget {
  @override
  _RecordPaymentState createState() => _RecordPaymentState();
}

class _RecordPaymentState extends State<RecordPayment> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  InputStyles inputStyles = new InputStyles();
  String requestErrors;
  bool _isLoading = false;
  TextEditingController _amountPaid = new TextEditingController();
  TextEditingController _receiptName = new TextEditingController();
  String paymentDate = "";
  String paymentType = "";
  int receivedPayment = 2;
  String methodOfPayment = "CASH";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Send Receipt")),
        body: SingleChildScrollView(
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                onInitialBuild: (state) {
                  setState(() {
                    _amountPaid.text =
                        state.readyInvoice.totalAmount.toString();
                    paymentType = "Full";
                  });
                },
                builder: (context, state) {
                  String businessId = state.currentBusiness.id;
                  String userId = state.loggedInUser.userId;

                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 2,
                                color: Theme.of(context).accentColor))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FormBuilder(
                                key: _fbKey,
                                initialValue: {
                                  'date': DateTime.now(),
                                  'accept_terms': false,
                                },
                                autovalidate: false,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Container(
                                          decoration: BoxDecoration(boxShadow: [
                                            inputStyles.boxShadowMain(context)
                                          ]),
                                          child: ChooseButton(
                                            buttonText: Text(
                                              state.readyInvoice == null
                                                  ? "Attach Invoice"
                                                  : state.readyInvoice.title,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            icon: attachInvoice,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        InvoiceList()),
                                              );
                                            },
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          inputStyles.boxShadowMain(context)
                                        ]),
                                        child: FormBuilderTextField(
                                          attribute: "receipt_name",
                                          decoration: inputStyles
                                              .inputMain("Receipt Name"),
                                          validators: [
                                            FormBuilderValidators.required()
                                          ],
                                          controller: _receiptName,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          inputStyles.boxShadowMain(context)
                                        ]),
                                        child: FormBuilderTextField(
                                          onChanged: (value) {
                                            if (int.parse(value) >=
                                                state
                                                    .readyInvoice.totalAmount) {
                                              setState(() {
                                                receivedPayment = 2;
                                                paymentType = "Full";
                                              });
                                            } else {
                                              setState(() {
                                                receivedPayment = 1;
                                                paymentType = "Part";
                                              });
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          attribute: "amount_paid",
                                          decoration: inputStyles
                                              .inputMain("Amount Paid"),
                                          validators: [
                                            FormBuilderValidators.required()
                                          ],
                                          controller: _amountPaid,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    DatePickerButtonLarge(
                                        onPressed: () {
                                          _pickDueDate();
                                        },
                                        buttonText: Text(
                                            paymentDate == ""
                                                ? "Payment Date"
                                                : paymentDate,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        icon: pickDate),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          inputStyles.dropDownMenu(context),
                                        ]),
                                        child: FormBuilderDropdown(
                                          onChanged: (value) {
                                            setState(() {
                                              methodOfPayment = value;
                                            });
                                          },
                                          attribute: "methodOfPayment",
                                          // initialValue: 'Male',
                                          hint: Text('Select Payment Method'),
                                          validators: [
                                            FormBuilderValidators.required()
                                          ],
                                          items: ['CHEQUE', 'CASH', 'TRANSFER']
                                              .map((methodOfPayment) =>
                                                  DropdownMenuItem(
                                                      value: methodOfPayment,
                                                      child: Text(
                                                          "$methodOfPayment")))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                              "I have Received Part Payment")),
                                      Radio(
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          value: 1,
                                          groupValue: receivedPayment,
                                          onChanged: (e) {})
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    receivedPayment = 1;
                                  });
                                },
                              ),
                              InkWell(
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                              "I have Received Full Payment")),
                                      Radio(
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          value: 2,
                                          groupValue: receivedPayment,
                                          onChanged: (e) {})
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    receivedPayment = 2;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              PrimaryButton(
                                buttonText: _isLoading
                                    ? LoaderLight()
                                    : Text("RECORD PAYMENT",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                onPressed: () {
                                  if (_fbKey.currentState.saveAndValidate()) {
                                    _previewReceipt(
                                        businessId,
                                        userId,
                                        state.readyInvoice,
                                        state.businessCustomers);
                                  }
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
                })));
  }

  void _previewReceipt(
      businessId, userId, Invoice invoice, List<Customer> customers) async {
    AlertSnackBarError alert = AlertSnackBarError();
    Customer invoiceCustomer =
        Invoice.getInvoiceCustomer(invoice.customerId, customers);

    if (paymentDate.isEmpty) {
      _scaffoldState.currentState
          .showSnackBar(alert.showSnackBar("Receipt payment date not set"));
      return;
    }
    Receipt _receipt = Receipt(
        "0",
        _receiptName.text,
        _amountPaid.text,
        paymentDate,
        methodOfPayment,
        paymentType,
        "Done",
        invoice.id,
        businessId,
        invoice.customerId,
        userId);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReceiptPreview(
                receipt: _receipt,
                customer: invoiceCustomer,
              )),
    );
  }

  _pickDueDate() {
    var maxTime = DateTime.now().year + 10;
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(maxTime, 6, 7),
        onChanged: (date) {}, onConfirm: (date) {
      String day = date.day.toString();
      String month = date.month.toString();
      String year = date.year.toString();

      setState(() {
        paymentDate = "$year-$month-$day";
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  final Widget pickDate = new SvgPicture.asset(
    SVGFiles.pick_date,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );
  final Widget attachInvoice = new SvgPicture.asset(
    SVGFiles.attach_invoice,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );
}
