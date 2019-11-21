import 'package:flutter/material.dart';

class InputStyles extends StatelessWidget {
  InputDecoration inputStyle;
  BoxShadow inputShadow;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  InputDecoration inputMain(inputText) {
    return inputStyle = new InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: inputText,
      border: InputBorder.none,
    );
  }

  BoxShadow boxShadowMain(context) {
    return inputShadow = BoxShadow(
        blurRadius: 4.0,
        color: Theme.of(context).primaryColorLight,
        offset: Offset(1.0, 3.0),
        spreadRadius: 1);
  }
}
