import 'package:akount_books/Api/BusinessPage/add_business.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/queries.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:akount_books/utilities/svg_files.dart';

class OTPVerification extends StatefulWidget {
  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

final Widget svg = new SvgPicture.asset(
  SVGFiles.otp_icon,
  semanticsLabel: 'Akount-book',
  allowDrawingOutsideViewBox: true,
);

class _OTPVerificationState extends State<OTPVerification> {
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme
              .of(context)
              .primaryColor),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
            ),
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
                              "2-Step Verification",
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
                                "Enter the verification code sent to your email address/phone number",
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
                            decoration: inputStyles.inputMain("Enter your OTP"),
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
                              : Text("SUBMIT",
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
    QueryResult result = await graphQLConfiguration.getGraphql().query(
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
        setState(() {
          _isLoading = false;
          _hasErrors = false;
        });
        Navigator.push(context,
            new MaterialPageRoute(builder: ((context) => AddBusiness())));
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
