import 'package:flutter/material.dart';

class ViewInvoiceFieldCard extends StatelessWidget {
  final String title;
  final dynamic value;

  ViewInvoiceFieldCard({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2-50,
            child: Text(
              title,
              style: TextStyle(fontSize:13, color: Colors.black),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2-10,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize:13, color: title == "Amount Due"? Color.fromRGBO(243, 139, 54, 1):Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}


class ViewInvoiceFieldCardBold extends StatelessWidget {
  final String title;
  final dynamic value;

  ViewInvoiceFieldCardBold({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2-50,
            child: Text(
              title,
              style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2-10,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize:15, color: title == "Amount Due"? Color.fromRGBO(243, 139, 54, 1):Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}