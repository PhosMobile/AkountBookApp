import 'package:akount_books/Api/BusinessPage/create_customer.dart';
import 'package:akount_books/Api/BusinessPage/create_invoice.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localstorage/localstorage.dart';

final Widget svg = new SvgPicture.asset(
  SVGFiles.success_icon,
  semanticsLabel: 'Akount-book',
  allowDrawingOutsideViewBox: true,
);

class BusinessCreated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = new LocalStorage('some_key');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pushNamed(context, "/user_dashboard");
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
          ),
          child: new Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      svg,
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "You have successfully setup your business page",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  PrimaryButton(
                      buttonText: Text("ADD INVOICE",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        storage.deleteItem("fromRegistration");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddInvoice()),
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  SecondaryButton(
                      buttonText: Text("ADD CUSTOMER",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        storage.deleteItem("fromRegistration");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddCustomer()),
                        );
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
