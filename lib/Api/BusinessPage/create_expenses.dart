import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';

class AddExpenses extends StatefulWidget {
  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  String phone;
  String email;
  TextEditingController _expenseName = new TextEditingController();
  TextEditingController _quantity = new TextEditingController();
  TextEditingController _businessDescription = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  String currency = "NGN";

  validate(value, errorText) {
    if (value.isEmpty) {
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Add Expense")),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0),
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(30),
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
                        autovalidate: true,
                        child: Column(
                          children: <Widget>[
                            _hasErrors
                                ? RequestError(errorText: requestErrors)
                                : Container(),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  inputStyles.boxShadowMain(context)
                                ]),
                                child: FormBuilderTextField(
                                  attribute: "expense_name",
                                  decoration:
                                      inputStyles.inputMain("Expense Name"),
                                  validators: [FormBuilderValidators.required()],
                                  controller: _expenseName,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2 - 50,
                                  decoration: BoxDecoration(boxShadow: [
                                    inputStyles.boxShadowMain(context)
                                  ]),
                                  child: FormBuilderTextField(
                                    keyboardType: TextInputType.number,
                                    attribute: "quantity",
                                    decoration: inputStyles.inputMain("Quantity"),
                                    validators: [
                                      FormBuilderValidators.required()
                                    ],
                                    controller: _quantity,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2 - 50,
                                  decoration: BoxDecoration(boxShadow: [
                                    inputStyles.boxShadowMain(context)
                                  ]),
                                  child: FormBuilderTextField(
                                    keyboardType: TextInputType.number,
                                    attribute: "price",
                                    decoration: inputStyles.inputMain("Price"),
                                    validators: [
                                      FormBuilderValidators.required()
                                    ],
                                    controller: _price,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  inputStyles.boxShadowMain(context)
                                ]),
                                child: FormBuilderTextField(
                                  attribute: "Description",
                                  decoration:
                                      inputStyles.inputMain("Description"),
                                  validators: [
                                    FormBuilderValidators.min(30,
                                        errorText:
                                            "Business can not be short than 30 character"),
                                    FormBuilderValidators.required()
                                  ],
                                  controller: _businessDescription,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DatePickerButtonFull(
                          onPressed: () {
                            _pickExpenseDate();
                          },
                          buttonText: Text("Date"),
                          icon: Icon(Icons.date_range)),
                      SizedBox(
                        height: 40,
                      ),
                      PrimaryButton(
                        buttonText: _isLoading
                            ? LoaderLight()
                            : Text("ADD EXPENSE",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.white)),
                        onPressed: () {
                          if (_fbKey.currentState.saveAndValidate()) {
                            _registerUser();
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
          ),
        ));
  }

  _pickExpenseDate() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(2019, 6, 7), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      print('confirm $date');
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void _registerUser() async {
    setState(() {
      _isLoading = true;
    });
  }
}
