import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  TextEditingController _itemName = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _quantity = new TextEditingController();
  TextEditingController _price = new TextEditingController();

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
            title: HeaderTitle(headerText: "Add New Item")),
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
                                attribute: "Item Name",
                                decoration: inputStyles.inputMain("Item Name"),
                                validators: [FormBuilderValidators.required()],
                                controller: _itemName,
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
                                attribute: "description",
                                decoration: inputStyles
                                    .inputMain("Description Address"),
                                controller: _description,
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    PrimaryButton(
                      buttonText: _isLoading
                          ? LoaderLight()
                          : Text("ADD ITEM",
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
