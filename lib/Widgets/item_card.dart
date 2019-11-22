import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Models/item.dart';
import '../utilities/svg_files.dart';

class ItemCard extends StatelessWidget{
  final Widget addItem = new SvgPicture.asset(
    SVGFiles.add_item,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );
  final Item item;
  ItemCard({@required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:  Color.fromRGBO(233, 237, 240, .2)
      ),
      padding: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left:20.0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    right: 15.0),
                child: addItem),
            Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                      color: Colors.blueGrey[20]),
                )),
          ],
        ),
      ),
    );
  }
}


