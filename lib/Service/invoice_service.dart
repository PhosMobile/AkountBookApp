import 'dart:io';

import 'package:akaunt/Api/BusinessPage/upload_file.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Resources/app_config.dart';
import 'package:http/http.dart' as http;

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
          print(response.body);
          print(response.statusCode);
        }
      });
    }
      }
  sendViaWhatsApp(Invoice invoice, Customer customer) {}
  sendViaSMS(Invoice invoice, Customer customer) {}
}
