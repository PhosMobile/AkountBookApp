import 'package:flutter/material.dart';
class AlertSnackBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  SnackBar showSnackBar(alertText){
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color.fromRGBO(4, 100, 183, 1),
        content: Container(
          child: Text("$alertText", textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
        ),
      duration: Duration(seconds: 3),
    );
  }
}
