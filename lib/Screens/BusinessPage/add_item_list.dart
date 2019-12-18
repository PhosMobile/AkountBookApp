import 'package:akaunt/Api/BusinessPage/create_item.dart';
import 'package:akaunt/AppState/actions/item_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/item.dart';
import 'package:akaunt/Widgets/HeaderTitle.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/item_card.dart';
import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddItemList extends StatefulWidget {
  @override
  _AddItemListState createState() => _AddItemListState();
}

class _AddItemListState extends State<AddItemList> {
  List<Item> selectedItems = [];
  final Widget addItem = new SvgPicture.asset(
    SVGFiles.add_item,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: HeaderTitle(headerText: "Select Item")),
      body: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
        ),
        child: StoreConnector<AppState, AppState>(
            onInit: (store) {
              store.state.invoiceItems.forEach((item) {
                selectedItems.add(item);
              });
            },
            converter: (store) => store.state,
            builder: (context, state) {
              List<Item> businessItems = state.businessItems;
              if (businessItems.length == 0) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          child: ChooseButton(
                            buttonText: Text(
                              "Add Item",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            icon: addItem,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddItem()),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text("No Items"),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                    padding: EdgeInsets.only(top: 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            child: ChooseButton(
                              buttonText: Text(
                                "Add Items",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              icon: addItem,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddItem()),
                                );
                              },
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          width: MediaQuery.of(context).size.width-4,
                          padding: EdgeInsets.only(top: 10,bottom: 5,left: 20),
                            child: Text(
                              "Item List",
                              textAlign: TextAlign.left,
                            )
                            ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: ListView.builder(
                                itemCount: businessItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, bottom: 4.0),
                                    child: Container(
                                        child: InkWell(
                                      child: Container(
                                          child: ItemCard(
                                        selected: selectedItems
                                                .contains(businessItems[index])
                                            ? true
                                            : false,
                                        item: businessItems[index],
                                        businessCurrency:
                                            state.currentBusiness.currency,
                                      )),
                                      onTap: () {
                                        if (selectedItems
                                            .contains(businessItems[index])) {
                                          setState(() {
                                            selectedItems
                                                .remove(businessItems[index]);
                                          });
                                        } else {
                                          setState(() {
                                            selectedItems
                                                .add(businessItems[index]);
                                          });
                                        }
                                      },
                                    )),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ));
              }
            }),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child: PrimaryButton(
              onPressed: () {
                saveInvoiceItems(context, selectedItems);
              },
              buttonText: Text(
                "Add Items",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }

  saveInvoiceItems(context, List<Item> items) {
    final invoiceItems = StoreProvider.of<AppState>(context);
    invoiceItems.dispatch(AddInvoiceItems(payload: items));
    Navigator.pop(context);
  }
}
