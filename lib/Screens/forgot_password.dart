import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Widgets/Input_styles.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/error.dart';
import 'package:akaunt/Widgets/loader_widget.dart';
import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

final Widget svg = new SvgPicture.asset(
  SVGFiles.forgot_pwd_icon,
  semanticsLabel: 'Akaunt-book',
  allowDrawingOutsideViewBox: true,
);

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  TextEditingController _email = new TextEditingController();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        width: 2, color: Theme.of(context).accentColor))),
            padding: EdgeInsets.only(top: 60),
            child: new Center(
                child: FormBuilder(
              key: _fbKey,
              initialValue: {
                'date': DateTime.now(),
                'accept_terms': false,
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                    SizedBox(
                      height: 30,
                    ),
                    _hasErrors
                        ? RequestError(errorText: requestErrors)
                        : Container(),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [inputStyles.boxShadowMain(context)]),
                      child: FormBuilderTextField(
                        attribute: "email",
                        decoration: inputStyles.inputMain("Email Address"),
                        validators: [
                          FormBuilderValidators.email(
                              errorText: "Invalid Email"),
                          FormBuilderValidators.required(
                              errorText: "Cannot be Empty")
                        ],
                        controller: _email,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                      buttonText: _isLoading
                          ? LoaderLight()
                          : Text("RESET PASSWORD",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          _getPasswordReset();
                        }
                      },
                    ),
                  ],
                ),
              ),
            )),
          ),
        ));
  }

  _getPasswordReset() async {
    setState(() {
      _isLoading = true;
    });
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations forgotPassword = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
          MutationOptions(document: forgotPassword.forgotPassword(_email.text)),
        );
    if (!result.hasErrors) {
      setState(() {
        _isLoading = false;
        _hasErrors = false;
      });

      if (result.data.data["forgotPassword"]["status"] == "EMAIL_NOT_SENT") {
        setState(() {
          requestErrors = result.data.data["forgotPassword"]["message"];
          _isLoading = false;
          _hasErrors = true;
        });
      } else {
        _email.text = "";
        Navigator.pushNamed(context, "/email_sent");
      }
    } else {
      print(result.errors);
      setState(() {
        requestErrors = result.errors.toString().substring(10, 36);
        _isLoading = false;
        _hasErrors = true;
      });
    }
  }
}
