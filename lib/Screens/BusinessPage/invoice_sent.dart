import 'package:akaunt/Api/BusinessPage/create_invoice.dart';
import 'package:akaunt/Api/BusinessPage/record_payment.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Screens/UserPage/dasboard.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

final Widget svg = new SvgPicture.asset(
  SVGFiles.success_icon,
  semanticsLabel: 'Akaunt-book',
  allowDrawingOutsideViewBox: true,
);

class InvoiceSent extends StatelessWidget {
  final Customer customer;
  final String via;

  const InvoiceSent({@required this.customer, @required this.via});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          automaticallyImplyLeading: false,
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(
                      currentTab: 0,
                    )),
              );
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: 2, color: Theme.of(context).accentColor))),
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
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "You have successfully sent an  \ninvoice to ${customer.name} \n via $via",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  PrimaryButton(
                      buttonText: Text("SEND REMINDER",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddInvoice()),
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  SecondaryButton(
                      buttonText: Text("SEND RECEIPT",
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecordPayment()),
                        );
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    child: Text("BACK TO INVOICES PAGE",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Dashboard(
                                  currentTab: 0,
                                )),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
