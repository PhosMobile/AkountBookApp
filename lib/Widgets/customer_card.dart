import 'package:akaunt/Models/customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utilities/svg_files.dart';

class CustomerCard extends StatelessWidget{
  final Widget addCustomer = new SvgPicture.asset(
    SVGFiles.add_customer,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );
  final Customer customer;
  CustomerCard({@required this.customer});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:  Color.fromRGBO(248, 248, 248, 1)
      ),
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Padding(
        padding: const EdgeInsets.only(left:20.0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    right: 15.0),
                child: addCustomer),
            Expanded(
                child: Text(
                  customer.name,
                  style: TextStyle(
                      color: Colors.blueGrey[20]),
                )),
          ],
        ),
      ),
    );
  }
}


