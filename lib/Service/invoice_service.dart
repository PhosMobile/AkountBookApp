import 'dart:io';
import 'package:akaunt/Api/BusinessPage/upload_file.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Resources/app_config.dart';
import 'package:akaunt/Screens/BusinessPage/invoice_sent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sms/flutter_sms.dart';

class InvoiceService {
  http.Response response;
  sendViaEmail(Invoice invoice, Customer customer, String path, context) async {
    final File file = File(path);
    var firebaseRef =
    await UploadFile().uploadInvoice(file);
    if (firebaseRef == null) {
    } else {
      firebaseRef.getDownloadURL().then((fileURL) async {
        var url = "${AppConfig.of(context).apiEndpoint}/api/send_file";
        response =
        await http.post(
            url, body: {"title": invoice.title,'summary':invoice.summary, "url": fileURL, "email": customer.email, "customerName":customer.name});
            print(url);
        if (response.statusCode == 200) {

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InvoiceSent(customer: customer,via: "Email")),
          );
        }else{
          print(response.body);
        }
      });
    }
}
  sendViaWhatsApp(Invoice invoice, Customer customer, String path, context) {}
  sendViaSMS(Invoice invoice, Customer customer, String path, context) async {
    print("SMS");
    final File file = File(path);
    var firebaseRef =
        await UploadFile().uploadInvoice(file);
    if (firebaseRef == null) {
      print("did not send");
    } else {
      firebaseRef.getDownloadURL().then((fileURL) async {
        String message = "${invoice.title} \n , ${invoice.summary} \n Total: ${invoice.totalAmount} download pdf using this link: $fileURL";
        String _result = await FlutterSms
            .sendSMS(message: message, recipients: [customer.phone])
            .catchError((onError) {
          print(onError);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InvoiceSent(customer: customer,via: "SMS")),
        );
      });
    }

  }
}
