
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/utilities/currency_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Models/item.dart';
import '../utilities/svg_files.dart';


class InvoiceItemCard extends StatelessWidget{
  final Widget addItem = new SvgPicture.asset(
    SVGFiles.add_item,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );

  final Item item;
  final String businessCurrency;
  InvoiceItemCard({@required this.item, @required this.businessCurrency});

  @override
  Widget build(BuildContext context) {
      int amount = int.parse(item.price ) * int.parse(item.quantity);
    return StoreConnector<AppState, AppState>(
        builder: (context, state){
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
                    width: MediaQuery.of(context).size.width / 3-30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          item.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize:12, color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          "${CurrencyConverter().formatPrice(int.parse(item.price), state.currentBusiness.currency)} each",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize:12,color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 4+30,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        item.description,
                        style: TextStyle(fontSize:12,color: Theme.of(context).primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 4-20,
                    child: Text(
                      CurrencyConverter()
                          .formatPrice(amount, businessCurrency),
                      style: TextStyle(fontSize:12,color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        }, converter: (store)=>store.state);
  }
}


