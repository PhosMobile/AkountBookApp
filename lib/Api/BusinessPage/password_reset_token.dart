import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Graphql/queries.dart';
import 'package:akaunt/Screens/login.dart';
import 'package:akaunt/Widgets/Input_styles.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/error.dart';
import 'package:akaunt/Widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:akaunt/utilities/svg_files.dart';

class PasswordResetToken extends StatefulWidget {
  final String newPassword;
  final String userId;
  const PasswordResetToken({@required this.newPassword, @required this.userId});

  @override
  _PasswordResetTokenState createState() => _PasswordResetTokenState();
}

final Widget svg = new SvgPicture.asset(
  SVGFiles.otp_icon,
  semanticsLabel: 'Akaunt-book',
  allowDrawingOutsideViewBox: true,
);

class _PasswordResetTokenState extends State<PasswordResetToken> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  TextEditingController _otp = new TextEditingController();

  bool _isLoading = false;
  String requestErrors;
  bool _hasErrors = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
            ),
            height: MediaQuery.of(context).size.height,
            child: new Center(
                child: FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'date': DateTime.now(),
                    'accept_terms': false,
                  },
                  autovalidate: false,
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
                              "Password Reset ",
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
                                "Enter the password reset token sent to your email address",
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
                            keyboardType: TextInputType.number,
                            attribute: "otp",
                            decoration: inputStyles.inputMain("Enter your Reset Token"),
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Cannot be Empty")
                            ],
                            controller: _otp,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        PrimaryButton(
                          buttonText: _isLoading
                              ? LoaderLight()
                              : Text("RESET",
                              style:
                              TextStyle(fontSize: 16, color: Colors.white)),
                          onPressed: () {
                            if (_fbKey.currentState.saveAndValidate()) {
                              _otpVerification();
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

  void _otpVerification() async {
    setState(() {
      _isLoading = true;
    });

    GqlConfig graphQLConfiguration = GqlConfig();

    Queries queries = Queries();
    QueryResult result = await graphQLConfiguration.getGraphql(context).query(
      QueryOptions(
          document: queries.getOTP,
          variables: <String, dynamic>{"otp": _otp.text}),
    );
    if (!result.hasErrors) {
      if (result.data["get_otp"] == null) {
        setState(() {
          requestErrors = "Incorrect Token";
          _isLoading = false;
          _hasErrors = true;
        });
      } else {
        print(widget.userId);
        print(widget.newPassword);
        Mutations updateUser = new Mutations();
        QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
            MutationOptions(
                document: updateUser.updatePassword(widget.userId,  widget.newPassword)));

        if(!result.hasErrors){
          setState(() {
            _isLoading = false;
            _hasErrors = false;
          });
          Navigator.push(context,
              new MaterialPageRoute(builder: ((context) => Login())));
        }else {
          print(result.errors);
          setState(() {
            requestErrors = "Incorrect Token";
            _isLoading = false;
            _hasErrors = true;
          });
        }
    }

    } else {
      setState(() {
        requestErrors = "Error Verifying your Toke. please try again later";
        _isLoading = false;
        _hasErrors = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
