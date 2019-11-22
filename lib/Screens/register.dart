import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:otp/otp.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/social_sign_up.dart';
import 'package:akount_books/Api/http_api.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  String phone;
  String email;
  TextEditingController _userName = new TextEditingController();
  TextEditingController _phone_email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  validate(value, errorText) {
    if (value.isEmpty) {
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          logo.miniLogoAvatar(),
          SizedBox(height: 20),
          Text("Sign Up",
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
                      autovalidate: false,
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
                                attribute: "fullName",
                                decoration: inputStyles.inputMain("Full Name"),
                                validators: [
                                  FormBuilderValidators.max(70,
                                      errorText:
                                      "Name can no be longer than 70 character"),
                                  FormBuilderValidators.required()
                                ],
                                controller: _userName,
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
                                attribute: "email",
                                decoration: inputStyles.inputMain(
                                    "Email / Phone"),
                                validators: [
                                  FormBuilderValidators.email(
                                      errorText: "Invalid Email"),
                                  FormBuilderValidators.minLength(10,
                                      errorText: "Email/Phone to short")
                                ],
                                controller: _phone_email,
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
                                attribute: "password",
                                obscureText: true,
                                decoration: inputStyles.inputMain("Password"),
                                validators: [
                                  FormBuilderValidators.minLength(8,
                                      errorText: "Wrong password"),
                                  FormBuilderValidators.required()
                                ],
                                controller: _password,
                              ),
                            ),
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
                          : Text("SIGN UP",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          _registerUser();
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
                            "Sign In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme
                                    .of(context)
                                    .primaryColor),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/login");
                          },
                        )
                      ],
                    ),
                    SocialSignUp()
                  ],
                )),
          ),
        ],
      ),
        ));
  }

  void _registerUser() async {
    http.Response response;
    setState(() {
      _isLoading = true;
    });
    CallApi api = new CallApi();

    RegExp phoneRegex =
    new RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$");
    RegExp emailRegex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (phoneRegex.hasMatch(_phone_email.text.trim())) {
      setState(() {
        this.phone = _phone_email.text;
        this.email = _phone_email.text;
      });
    } else if (emailRegex.hasMatch(_phone_email.text.trim())) {
      setState(() {
        this.email = _phone_email.text;
      });
    } else {
      setState(() {
        requestErrors = "Wrong Email/Phone Format";
        _hasErrors = true;
      });
    }
    int otp = OTP.generateTOTPCode(
        "JBSWY3DPEHPK3PXP", DateTime
        .now()
        .millisecondsSinceEpoch);
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createUser = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql().mutate(
        MutationOptions(
            document: createUser.createUser(
                _userName.text, this.phone, this.email, _password.text, otp)));
    if (!result.hasErrors) {
      if (phoneRegex.hasMatch(_phone_email.text.trim())) {
        setState(() {
          requestErrors =
          "Phone not available now please use a valid email address";
          _isLoading = false;
          _hasErrors = true;
        });
      } else if (emailRegex.hasMatch(_phone_email.text.trim())) {
        var url = "http://10.0.2.2:8000/api/verify_otp_email";
        response =
        await http.post(url, body: {"email": email, "otp": otp.toString()});
      }
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        var user = result.data["create_user"];
        prefs.setStringList('user_credentials',
            [_phone_email.text, _password.text, user["id"]]);
        _userName.text = "";
        _password.text = "";
        _phone_email.text = "";

        setState(() {
          _isLoading = false;
          _hasErrors = false;
        });
        Navigator.pushNamed(context, "/otp_verifiy");
      } else {
        setState(() {
          requestErrors =
          "Error registering your Account, please try again later";
          _isLoading = false;
          _hasErrors = true;
        });
      }
    } else {
      setState(() {
        requestErrors = "Error Registering your account...pls try again";
        _isLoading = false;
        _hasErrors = true;
      });
    }
  }
}
