import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Service/invoice_service.dart';
import 'package:akaunt/Widgets/loading_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'dart:io';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      key: _scaffoldKey,
      path: widget.path,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          "Send Summary",
          style: TextStyle(fontSize: 14),
        ),
        actions: <Widget>[
          RaisedButton(
              child: Text(
                "Proceed",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.only(top: 0, bottom: 0),
              onPressed: () async {
                if (widget.sendVia == "Email") {
                  await InvoiceService().sendViaEmail(widget.invoice, widget.customer, widget.path,context);
                } else if (widget.sendVia == "SMS") {
                  InvoiceService().sendViaSMS(widget.invoice, widget.customer);
                } else {
                  InvoiceService().sendViaWhatsApp(widget.invoice, widget.customer);
                }
              })
        ],
      ),
    );
  }
}
