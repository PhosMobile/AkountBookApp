import 'dart:io';
import 'package:akount_books/Api/UserAcount/logged_in_user.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Screens/business_created.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBusiness extends StatefulWidget {
  @override
  _AddBusinessState createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  String phone;
  String email;
  TextEditingController _businessName = new TextEditingController();
  TextEditingController _businessEmail = new TextEditingController();
  TextEditingController _businessDescription = new TextEditingController();
  TextEditingController _businessAddress = new TextEditingController();
  String currency = "NGN";
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
            title: HeaderTitle(headerText: "Set Up a Business Page")),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0),
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
                                attribute: "Business Name",
                                decoration:
                                    inputStyles.inputMain("Business Name"),
                                validators: [
                                  FormBuilderValidators.max(70,
                                      errorText:
                                          "Business can not be longer than 70 character"),
                                  FormBuilderValidators.required()
                                ],
                                controller: _businessName,
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
                                controller: _businessEmail,
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                inputStyles.boxShadowMain(context)
                              ]),
                              child: FormBuilderTextField(
                                attribute: "office_address",
                                decoration:
                                    inputStyles.inputMain("Office Address"),
                                validators: [
                                  FormBuilderValidators.max(70,
                                      errorText:
                                          "Address can not be longer than 70 character"),
                                  FormBuilderValidators.required()
                                ],
                                controller: _businessAddress,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                inputStyles.boxShadowMain(context)
                              ]),
                              child: FormBuilderDropdown(
                                onChanged: (value) {
                                  setState(() {
                                    currency = value;
                                  });
                                },
                                attribute: "currency",
                                decoration:
                                    InputDecoration(labelText: "Currency"),
                                // initialValue: 'Male',
                                hint: Text('Select Business Currency'),
                                validators: [FormBuilderValidators.required()],
                                items: ['NGN', 'USD', 'EUR']
                                    .map((currency) => DropdownMenuItem(
                                        value: currency,
                                        child: Text("$currency")))
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
                          : Text("REGISTER BUSINESS",
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
        ));
  }

  void _registerUser() async {
    setState(() {
      _isLoading = true;
    });
    final LocalStorage storage = new LocalStorage('some_key');
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getStringList('user_credentials') ?? [];

    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createBusiness = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql().mutate(
        MutationOptions(
            document: createBusiness.createBusiness(
                _businessName.text,
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
      _businessName.text = "";
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
        storage.deleteItem("access_token");
        var access_token = result.data["login"];
        storage.setItem("access_token", access_token);
        storage.setItem("fromRegistration", "true");
        LoggedInUser().fetchLoggedInUser(context);
      } else {
        setState(() {
          requestErrors = result.errors.toString().substring(10, 36);
          _isLoading = false;
          _hasErrors = true;
        });
      }
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
