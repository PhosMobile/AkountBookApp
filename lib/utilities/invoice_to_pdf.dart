import 'dart:io';
import 'package:akaunt/Models/business.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/item.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:flutter/material.dart' as material;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class InvoiceToPdf {
  final Document pdf = Document();
  final Invoice invoice;
  final Business currentBusiness;
  final Customer customer;
  final List<Item> invoiceItem;
  final List<Receipt> receipts;
  final formatter = new NumberFormat("#,###");

  List<List<String>> items = [
    <String>['Items Name', 'Quantity', 'Amount'],
  ];

  List<List<String>> payments = [
    <String>['Receipt Name', 'Date', 'Amount Paid'],
  ];

  InvoiceToPdf(
      {@material.required this.invoice,
      @material.required this.currentBusiness,
      @material.required this.customer,
      @material.required this.invoiceItem,
      @material.required this.receipts,});

  Future<String> downloadPdf(cont) async {
    double balance = 0;
    invoiceItem.forEach((item) {
      items.add(<String>[
        '${item.name}',
        '${item.quantity}',
        '${formatter.format(double.parse(item.price) * double.parse(item.quantity))}'
      ]);
    });
    receipts.forEach((receipt) {
      payments.add(<String>[
        '${receipt.name}',
        '${receipt.paymentDate}',
        '${formatter.format(double.parse(receipt.amountPaid))}'
      ]);
      balance = balance + double.parse(receipt.amountPaid);
    });

    final PdfImage assetImage = await pdfImageFromImageProvider(
      pdf: pdf.document,
      image: material.NetworkImage(currentBusiness.imageUrl),
    );
    pdf.addPage(MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const BoxDecoration(
                  border: BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: Text('Portable Document Format',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (Context context) => <Widget>[
              Container(
                  width: material.MediaQuery.of(cont).size.width,
                  height: 80,
                  child: Image(
                    assetImage,
                  )),
              Header(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                    Container(
                        width: material.MediaQuery.of(cont).size.width - 100,
                        child: Text(currentBusiness.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25))),
                    Text(currentBusiness.address,
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                  ])),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 50,
                    child: Text(
                      "Invoice Name",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 10,
                    child: Text(
                      invoice.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 50,
                    child: Text(
                      "Invoice Date",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 10,
                    child: Text(
                      invoice.issueDate,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 50,
                    child: Text(
                      "Due Date",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 10,
                    child: Text(
                      invoice.dueDate,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 50,
                    child: Text(
                      "Amount Due",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 10,
                    child: Text(
                      invoice.totalAmount.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 50,
                    child: Text(
                      "Amount Due",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    width: material.MediaQuery.of(cont).size.width / 2 - 10,
                    child: Text(
                      invoice.totalAmount.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Header(level: 1, text: 'Items'),
              Table.fromTextArray(context: context, data: items),
              SizedBox(height: 20),
              Header(level: 1, text: 'Payment'),
              Table.fromTextArray(context: context, data: payments),
              Padding(padding: const EdgeInsets.all(10)),
              Paragraph(
                  text:
                      "Balance: ${formatter.format(invoice.totalAmount - balance)}"),
              Paragraph(text: invoice.summary),
              Text(invoice.notes)
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/${invoice.title}.pdf';

    final File file = File(path);
    file.writeAsBytesSync(pdf.save());
    return path;
  }
}
