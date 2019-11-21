import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestSuccess extends StatelessWidget {
  String successText;

  RequestSuccess({@required this.successText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text("$successText", textAlign: TextAlign.center),
      ),
    );
  }
}
