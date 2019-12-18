import 'package:flutter/material.dart';
class  InvoiceStatus extends StatelessWidget {
  final String status;
  final Color textColor;
  final Color avatarBgColor;

  const InvoiceStatus({Key key, this.status, this.textColor, this.avatarBgColor, }) : super(key: key);@override

  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text(
        "${status.toUpperCase()}",
        style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: avatarBgColor,
      radius: 25,
    );
  }
}
