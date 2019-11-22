import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Screens/BusinessPage/customers_list.dart';
import 'package:akount_books/Screens/BusinessPage/invoice_name.dart';
import 'package:akount_books/Screens/BusinessPage/item_list.dart';
import 'package:akount_books/Screens/business_created.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInvoice extends StatefulWidget {
  @override
  _AddInvoiceState createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  TextEditingController _businessEmail = new TextEditingController();
  TextEditingController _businessDescription = new TextEditingController();
  TextEditingController _businessAddress = new TextEditingController();
  String currency = "NGN";

  final Widget pickDate = new SvgPicture.asset(
    SVGFiles.pick_date,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );

  final Widget addCustomer = new SvgPicture.asset(
    SVGFiles.add_customer,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );

  final Widget addItem = new SvgPicture.asset(
    SVGFiles.add_item,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Create Invoice")),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 0, left: 20, right: 20),
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
                              ? RequestError(errorText: requestErrors)
                              : Container(),
                          SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Theme
                                        .of(context)
                                        .accentColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              child: Card(
                                            child: Container(
                                              child: Text(
                                                "INVOICE NAME",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w100,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ),
                                            elevation: 0.0,
                                          )),
                                          Container(
                                              child: Card(
                                            child: Container(
                                              child: Text(
                                                  "Project Name / Description",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .w100,)),

                                            ),
                                            elevation: 0.0,
                                          ))
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                              child: Card(
                                            child: Container(
                                              child: Text(
                                                "DRAFT",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w100,
                                                    color: Theme.of(context)
                                                        .primaryColor,

                                                ),
                                              ),
                                            ),
                                            elevation: 0.0,
                                          )),
                                          Container(
                                              child: Card(
                                            child: Container(
                                              child: Text("P.S/S.O Number"),
                                            ),
                                            elevation: 0.0,
                                          )),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddInvoiceName()),
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              DatePickerButton(
                                  onPressed: () {
                                    _pickInvoiceDate();
                                  },
                                  buttonText: Text("Invoice Date",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  icon: pickDate
                              ),
                              DatePickerButton(
                                  onPressed: () {
                                    _pickDueDate();
                                  },
                                  buttonText: Text("Due Date",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  icon: pickDate
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  inputStyles.boxShadowMain(context)
                                ]),
                                child: ChooseButton(
                                  buttonText: Text(
                                    "Add Customer",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  icon: addCustomer,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CustomerList()),
                                    );
                                  },
                                )),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  inputStyles.boxShadowMain(context)
                                ]),
                                child: ChooseButton(
                                  buttonText: Text(
                                    "Add Items",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  icon: addItem,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ItemList()),
                                    );
                                  },
                                )),
                          ),
                          SizedBox(height: 10),
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
                                  attribute: "sub_total",
                                  decoration:
                                      inputStyles.inputMain("Sub Total"),
                                  validators: [
                                    FormBuilderValidators.required()
                                  ],
                                  controller: _businessEmail,
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
                                  attribute: "total",
                                  decoration: inputStyles.inputMain("Total"),
                                  validators: [
                                    FormBuilderValidators.required()
                                  ],
                                  controller: _businessEmail,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                inputStyles.boxShadowMain(context)
                              ]),
                              child: FormBuilderTextField(
                                attribute: "Notes",
                                decoration: inputStyles.inputMain("Notes"),
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                                controller: _businessDescription,
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
                                attribute: "Footer",
                                decoration: inputStyles.inputMain("Footer"),
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                                controller: _businessDescription,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PrimaryMiniButton(
                          buttonText: _isLoading
                              ? LoaderLight()
                              : Text("SEND",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 14, color: Colors.white)),
                          onPressed: () {
                            if (_fbKey.currentState.saveAndValidate()) {
                              _registerUser();
                            }
                          },
                        ),
                        SecondaryMiniButton(
                          buttonText: _isLoading
                              ? LoaderLight()
                              : Text("SAVE DRAFT",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor)),
                          onPressed: () {
                            if (_fbKey.currentState.saveAndValidate()) {
                              _registerUser();
                            }
                          },
                        ),
                      ],
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
  _pickInvoiceDate() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(2019, 6, 7), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      print('confirm $date');
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  _pickDueDate() {
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
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getStringList('user_credentials') ?? [];

    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createBusiness = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql().mutate(
        MutationOptions(
            document: createBusiness.createBusiness(
                "",
                _businessEmail.text,
                _businessDescription.text,
                _businessAddress.text,
                currency,
                "null",
                user[2])));
    if (!result.hasErrors) {
      setState(() {
        _isLoading = false;
        _hasErrors = false;
      });
      _businessEmail.text = "";
      _businessDescription.text = "";
      _businessAddress.text = "";

      GqlConfig graphQLConfiguration = GqlConfig();
      Mutations login = new Mutations();
      QueryResult result = await graphQLConfiguration.getGraphql().mutate(
            MutationOptions(document: login.login(user[0], user[1])),
          );
      if (!result.hasErrors) {
        setState(() {
          _isLoading = false;
          _hasErrors = false;
        });
        var access_token = result.data.data["login"];
        prefs.setString('access_token', access_token["access_token"]);
        Navigator.pushNamed(context, "/user_dashboard");
      } else {
        setState(() {
          requestErrors = result.errors.toString().substring(10, 36);
          _isLoading = false;
          _hasErrors = true;
        });
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BusinessCreated()),
      );
    } else {
      print(result.errors);
      setState(() {
        requestErrors = "Error ...pls try again";
        _isLoading = false;
        _hasErrors = true;
      });
    }
  }
}
