import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';

class EmailSent extends StatefulWidget {
  @override
  _EmailSentState createState() => _EmailSentState();
}

final Widget svg = new SvgPicture.asset(
  SVGFiles.mail_icon,
  semanticsLabel: 'Akount-book',
  allowDrawingOutsideViewBox: true,
);

class _EmailSentState extends State<EmailSent> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  var wrongToken = '';
  var confirmPassword = "";
  var validEmail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: Container(
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
                        "We've sent you an email",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "Check your email and follow the instructions in the message",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  PrimaryButton(
                      buttonText: Text("BACK TO LOGIN PAGE",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/login");
                      })
                ],
              ),
            ),
          )),
        ));
  }
}
