import 'dart:io';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:image_picker/image_picker.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  TextEditingController _customerName = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  File _image;

  validate(value, errorText) {
    if (value.isEmpty) {
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Add New Customer")),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 0),
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
                          InkWell(
                            child: Text(
                              "IMPORT FROM CONTACT",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _hasErrors
                              ? RequestError(errorText: requestErrors)
                              : Container(),
                          InkWell(
                            child: ImageAvatars().attachImage(),
                            onTap: () async {
                              var image = await ImagePicker.pickImage(
                                  source: ImageSource.camera);
                              setState(() {
                                _image = image;
                              });
                            },
                          ),
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
                                attribute: "Customer Name",
                                decoration:
                                    inputStyles.inputMain("Customer Name"),
                                validators: [
                                  FormBuilderValidators.max(70,
                                      errorText:
                                          "Customer can not be longer than 70 character"),
                                  FormBuilderValidators.required()
                                ],
                                controller: _customerName,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                inputStyles.boxShadowMain(context)
                              ]),
                              child: FormBuilderTextField(
                                attribute: "email",
                                decoration:
                                    inputStyles.inputMain("Email Address"),
                                validators: [
                                  FormBuilderValidators.minLength(10,
                                      errorText: "Email too short")
                                ],
                                controller: _email,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                inputStyles.boxShadowMain(context)
                              ]),
                              child: FormBuilderTextField(
                                keyboardType: TextInputType.number,
                                attribute: "Phone Number",
                                decoration:
                                    inputStyles.inputMain("Phone Number"),
                                validators: [FormBuilderValidators.required()],
                                controller: _phone,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                inputStyles.boxShadowMain(context)
                              ]),
                              child: FormBuilderTextField(
                                attribute: "address",
                                decoration: inputStyles.inputMain(" Address"),
                                controller: _address,
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
                          : Text("ADD CUSTOMER",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          _addCustomer();
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
        ));
  }

  void _addCustomer() async {
    setState(() {
      _isLoading = true;
    });
  }
}
