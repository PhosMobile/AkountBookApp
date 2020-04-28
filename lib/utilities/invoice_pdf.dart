import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
class InvoicePDF extends StatefulWidget {
  final String path;
  final Customer customer;
  final String sendVia;
  final Invoice invoice;

  const InvoicePDF(
      {Key key,
        this.path,
        @required this.customer,
        @required this.sendVia,
        @required this.invoice
      })
      : super(key: key);

  @override
  _InvoicePDFState createState() => _InvoicePDFState();
}

class _InvoicePDFState extends State<InvoicePDF> {
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: widget.path,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          "${widget.invoice.title}",
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}


