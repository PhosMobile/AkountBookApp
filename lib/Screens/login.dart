import 'package:akount_books/Api/UserAcount/logged_in_user.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:akount_books/Widgets/social_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:localstorage/localstorage.dart';

class Login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<Login> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String requestErrors;
  InputStyles inputStyles = new InputStyles();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  ImageAvatars logo = new ImageAvatars();
  bool _isLoading = false;
  bool _hasErrors = false;

  bool error = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo.miniLogoAvatar(),
              SizedBox(height: 20),
              Text("Sign In",
                  style: TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        inputStyles.boxShadowMain(context)
                                      ]),
                                  child: FormBuilderTextField(
                                    attribute: "email",
                                    decoration: inputStyles.inputMain(
                                        "Email / Phone"),
                                    validators: [
                                      FormBuilderValidators.email(
                                          errorText: "Invalid Email"),
                                      FormBuilderValidators.minLength(10,
                                          errorText: "Email/Phone to short")
                                    ],
                                    controller: _email,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        inputStyles.boxShadowMain(context)
                                      ]),
                                  child: FormBuilderTextField(
                                    obscureText: true,
                                    attribute: "password",
                                    decoration: inputStyles.inputMain(
                                        "Password"),
                                    validators: [
                                      FormBuilderValidators.minLength(8,
                                          errorText: "Wrong password"),
                                      FormBuilderValidators.required()
                                    ],
                                    controller: _password,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    child: Text("Forgot password",
                                        style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .primaryColor)),
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/forgot_password");
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        PrimaryButton(
                          buttonText: _isLoading
                              ? LoaderLight()
                              : Text("SIGN IN",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white)),
                          onPressed: () {
                            if (_fbKey.currentState.saveAndValidate()) {
                              _loginUser();
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already ave an account?",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, "/register");
                              },
                            )
                          ],
                        ),
                        SocialSignUp(),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  void _loginUser() async {
    final LocalStorage storage = new LocalStorage('some_key');
    setState(() {
      _isLoading = true;
    });
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations login = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql().mutate(
      MutationOptions(document: login.login(_email.text, _password.text)),
    );
    if (!result.hasErrors) {
      setState(() {
        _isLoading = false;
        _hasErrors = false;
      });
      storage.deleteItem("access_token");
      var access_token = result.data["login"];
      storage.setItem("access_token", access_token);
      LoggedInUser().fetchLoggedInUser(context);
    } else {
      setState(() {
        requestErrors = result.errors.toString().substring(10, 36);
        _isLoading = false;
        _hasErrors = true;
      });
    }
  }
}
