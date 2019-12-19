import 'package:flutter/material.dart';

class ViewInvoiceFieldCard extends StatelessWidget {
  final String title;
  final dynamic value;

  ViewInvoiceFieldCard({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2-50,
            child: Text(
              title,
              style: TextStyle(fontSize:13, color: Colors.black),
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize:13, color: title == "Amount Due"? Color.fromRGBO(243, 139, 54, 1):Colors.black),
          ),
        ],
      ),
    );
  }
}
