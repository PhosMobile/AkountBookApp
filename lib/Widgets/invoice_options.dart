import 'package:flutter/material.dart';

class InvoiceOption extends StatefulWidget {
  @override
  _InvoiceOptionState createState() => _InvoiceOptionState();
}

class _InvoiceOptionState extends State<InvoiceOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:   Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 350,
          child: Column(
          ),
        ),
      )
    );
  }
}

