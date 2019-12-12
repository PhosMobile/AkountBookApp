
import 'package:akount_books/utilities/currency_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Models/item.dart';
import '../utilities/svg_files.dart';


class InvoiceItemCard extends StatelessWidget{
  final Widget addItem = new SvgPicture.asset(
    SVGFiles.add_item,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );

  final Item item;
  final String businessCurrency;
  InvoiceItemCard({@required this.item, @required this.businessCurrency});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:  Colors.white,
        border: Border.all(width: 0.5, color: Colors.blueGrey)
      ),
      padding: EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.only(left:0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 4-30,
              child: Text(
                item.name,
                textAlign: TextAlign.left,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4+50,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  item.description,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4-50,
              child: Text(
                CurrencyConverter()
                    .formatPrice(int.parse(item.price), businessCurrency),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


