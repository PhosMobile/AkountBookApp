import 'package:akaunt/Widgets/logo_avatar.dart';
import 'package:flutter/material.dart';
import 'package:akaunt/Widgets/buttons.dart';


class Home extends StatelessWidget {
  final ImageAvatars logo = new ImageAvatars();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    logo.largeLogoAvatar(),
                    SizedBox(
                      height: 10,
                    ),
                    Text("AKAUNT BOOK",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2.0,
                          color: Theme
                              .of(context)
                              .primaryColor,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Keep your business account records easily and efficiently",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    PrimaryButton(
                      buttonText: Text(
                        "GET STARTED",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: Text(
                            "Log In",
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
                    )
                  ],
                ))));
  }
}
