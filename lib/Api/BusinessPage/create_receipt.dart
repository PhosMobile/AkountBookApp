import 'package:akount_books/AppState/actions/receipt_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/receipt.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:akount_books/Widgets/AlertSnackBar.dart';

class AddReceipt extends StatefulWidget {
  final int invoicePrice;

  const AddReceipt({ this.invoicePrice});
  @override
  _AddReceiptState createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  InputStyles inputStyles = new InputStyles();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  TextEditingController _amountPaid = new TextEditingController();
  String paymentDate = "";
  String paymentType = "";

  String methodOfPayment = "CASH";
  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      key: _scaffoldState,
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme
                .of(context)
                .primaryColor),
            title: HeaderTitle(headerText: widget.invoicePrice != null ? "Record Full Payment":"Record Part Payment")),
        body: SingleChildScrollView(
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) {
                  String businessId = state.currentBusiness.id;
                  String userId = state.loggedInUser.userId;

                  if(widget.invoicePrice != null){
                    _amountPaid.text = widget.invoicePrice.toString();
                      paymentType = "Full";
                  }else{
                      paymentType = "Part";
                  }
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
                    ),
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
                                        _hasErrors
                                            ? RequestError(
                                            errorText: requestErrors)
                                            : Container(),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10),
                                          child: Container(
                                            decoration: BoxDecoration(boxShadow: [
                                              inputStyles.boxShadowMain(context)
                                            ]),
                                            child: FormBuilderTextField(
                                              keyboardType: TextInputType.number,
                                              attribute: "amount_paid",
                                              decoration:
                                              inputStyles.inputMain("Amount Paid"),
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
                                          padding: const EdgeInsets.only(bottom: 10),
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
                                                  .map((methodOfPayment) => DropdownMenuItem(
                                                  value: methodOfPayment,
                                                  child: Text("$methodOfPayment")))
                                                  .toList(),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
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
                                        _addReceipt(businessId, userId);
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
  void _addReceipt(businessId, userId) async {
    AlertSnackBar alert = AlertSnackBar();
    if (paymentDate == "") {
      _scaffoldState.currentState
          .showSnackBar(alert.showSnackBar("Receipt has no data"));
      return;
    }
    final addReceipt = StoreProvider.of<AppState>(context);
    final _state = addReceipt.state;
      Receipt _receipt = new Receipt(
      "0",
        _state.invoiceName.title+"001",
        _amountPaid.text,
        paymentDate,
        methodOfPayment,
          paymentType, "done",
          _state.readyInvoice.id,
          businessId,
          _state.invoiceCustomer.id,
          userId
      );
      addReceipt.dispatch(UpdateInvoiceReceipts(payload: _receipt));
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
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
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );

}
