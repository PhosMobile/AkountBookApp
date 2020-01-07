import 'package:akaunt/utilities/currency_convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Models/item.dart';
import '../utilities/svg_files.dart';

class ItemCard extends StatelessWidget {
  final Widget addItem = new SvgPicture.asset(
    SVGFiles.add_item,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );
  final Item item;
  final String businessCurrency;
  final bool selected;

  final Widget selectedIcon = new SvgPicture.asset(
    SVGFiles.selected,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
    width: 10,
    height: 10,
  );
  final Widget selectIcon = new SvgPicture.asset(
    SVGFiles.select,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
    width: 10,
    height: 10,
  );

  ItemCard(
      {@required this.item,
      @required this.businessCurrency,
      @required this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromRGBO(248, 248, 248, 1)),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 60,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 4-30,
              child: Text(
              item.name,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.blueGrey[20]),
            ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  item.description,
                  style: TextStyle(color: Colors.blueGrey[20]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Text(
                CurrencyConverter()
                    .formatPrice(int.parse(item.price)*int.parse(item.quantity), businessCurrency),
                style: TextStyle(color: Colors.blueGrey[20]),
              ),
            ),
            Container(width:20, height: 20, child: selected ? selectedIcon : selectIcon)
          ],
        ),
    );
  }
}
