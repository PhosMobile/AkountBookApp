import 'package:flutter/material.dart';

class InputStyles {
  InputDecoration inputStyle;
  BoxShadow inputShadow;
  BoxDecoration sendSelected;
  BoxDecoration unSendSelected;

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


  BoxDecoration setSendSelected(context) {
    return sendSelected = BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColor),
        color: Theme.of(context).primaryColor,
        boxShadow: [
          boxShadowMain(context)
        ]);
  }

  BoxDecoration setSendUnSelected(context) {
     return sendSelected = BoxDecoration(
        border: Border.all(
            width: 1,
            color: Colors.grey),
        color: Colors.white,
        boxShadow: [
          boxShadowMain(context)
        ]);
  }



}
