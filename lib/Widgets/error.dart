import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestError extends StatelessWidget {
  String errorText;

  RequestError({@required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 127, 127, 0.5),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text("$errorText", textAlign: TextAlign.center),
      ),
    );
  }
}
