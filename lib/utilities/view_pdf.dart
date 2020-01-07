import 'package:akaunt/Models/customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class ViewPdf extends StatelessWidget {
  final String path;
  final Customer customer;

  const ViewPdf({Key key, this.path, @required this.customer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        title: Text("Send Summary", style: TextStyle(fontSize: 14),),
        actions: <Widget>[
          RaisedButton(
              child: Text("Proceed", style: TextStyle(color: Colors.white),),
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.only(top: 0, bottom: 0),
              onPressed: (){
                print("sent");
              }
          )
        ],
      ),
    );
  }
}
