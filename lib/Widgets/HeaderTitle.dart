import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  final String headerText;

  HeaderTitle({@required this.headerText});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$headerText",
      style: TextStyle(color: Colors.black),
    );
  }
}
