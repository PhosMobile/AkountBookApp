import 'package:akaunt/Api/BusinessPage/password_reset_token.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Graphql/queries.dart';
import 'package:akaunt/Resources/app_config.dart';
import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:akaunt/Widgets/AlertSnackBar.dart';
import 'package:akaunt/Widgets/error.dart';
import 'package:akaunt/Widgets/loader_widget.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akaunt/Widgets/Input_styles.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:otp/otp.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}
class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AlertSnackBar alert = AlertSnackBar();
  InputStyles inputStyles = new InputStyles();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;

  TextEditingController _password = new TextEditingController();
  TextEditingController _cPassword = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  validate(value, errorText) {
    if (value.isEmpty) {
      return '';
    }
    return null;
  }
  final Widget svg = new SvgPicture.asset(
  SVGFiles.forgot_pwd_icon,
  semanticsLabel: 'Akaunt-book',
  allowDrawingOutsideViewBox: true,
);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                              Column(
                                children: <Widget>[
                                  svg,
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Forgot Password",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text(
                                      "Fill in your registered email address to reset password",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
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
                                    attribute: "password",
                                    obscureText: true,
                                    maxLines: 1,
                                    decoration: inputStyles.inputMain(
                                        "New Password"),
                                    validators: [
                                      FormBuilderValidators.minLength(8,
                                          errorText: "Wrong password"),
                                      FormBuilderValidators.required()
                                    ],
                                    controller: _password,
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
                                    attribute: "confirm password",
                                    obscureText: true,
                                    maxLines: 1,
                                    decoration: inputStyles.inputMain(
                                        "Confirm Password"),
                                    validators: [
                                      FormBuilderValidators.minLength(8,
                                          errorText: "Wrong password"),
                                      FormBuilderValidators.required()
                                    ],
                                    controller: _cPassword,
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
                              : Text("RESET PASSWORD",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white)),
                          onPressed: () {
                            if(_password.text != _cPassword.text) {
                              _scaffoldKey.currentState.showSnackBar(
                                  alert.showSnackBar(
                                      "Password does not match"));
                            }else{
                              if (_fbKey.currentState.saveAndValidate()) {
                                _registerUser();
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                "Sign in",
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
    http.Response response;
    GqlConfig graphQLConfiguration = GqlConfig();
    Queries queries = Queries();
    QueryResult result = await graphQLConfiguration.getGraphql(context).query(
      QueryOptions(
        document: queries.getUserEmail,
        variables: {
          "email":_email.text
        }
      ),
    );

    if (!result.hasErrors) {
      int otp = OTP.generateTOTPCode(
          "JBSWY3DPEHPK3PXP", DateTime
          .now()
          .millisecondsSinceEpoch);
      var data = result.data["get_user_email"];
      var url = "${AppConfig.of(context).apiEndpoint}/api/verify_otp_email";
      response =
      await http.post(
          url, body: {"email": data["email"], "otp": otp.toString()});

      if (response.statusCode == 200) {
        Mutations updateUser = new Mutations();
        QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
            MutationOptions(
                document: updateUser.updateUser(data["id"],  otp.toString())));

        if(!result.hasErrors){
          Navigator.push(context,
              new MaterialPageRoute(builder: ((context) => PasswordResetToken(newPassword: _password.text,userId:data["id"]))));
        }else{
          print(result.errors);
          _scaffoldKey.currentState.showSnackBar(
            alert.showSnackBar(
                "Error resetting password"));
      }
      } else {
        print(result.errors);
        _scaffoldKey.currentState.showSnackBar(
            alert.showSnackBar(
                "Error resetting password"));
      }
    } else {
      print(result.errors);
      _scaffoldKey.currentState.showSnackBar(
          alert.showSnackBar(
              "Invalid email"));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
