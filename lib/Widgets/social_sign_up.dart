import 'package:flutter/material.dart';

class SocialSignUp extends StatefulWidget {
  @override
  _SocialSignUpState createState() => _SocialSignUpState();
}

class _SocialSignUpState extends State<SocialSignUp> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
        InkWell(
          child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 10,
              backgroundImage: AssetImage("images/facebook.png")),
          onTap: () {},
        ),
        SizedBox(
          width: 40,
        ),
        InkWell(
          child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 10,
              backgroundImage: AssetImage("images/google.png")),
          onTap: () {},
        ),
        SizedBox(
          width: 40,
        ),
        InkWell(
          child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              backgroundImage: AssetImage("images/twitter.png")),
          onTap: () {},
        ),
      ],
    );
  }
}
