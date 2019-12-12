import 'package:akount_books/Api/BusinessPage/create_item.dart';
import 'package:akount_books/AppState/actions/item_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/item_card.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditItemList extends StatefulWidget {
  @override
  _EditItemListState createState() => _EditItemListState();
}

class _EditItemListState extends State<EditItemList> {
  List<Item> selectedItems = [];
  final Widget addItem = new SvgPicture.asset(
    SVGFiles.add_item,
    semanticsLabel: 'Akount-book',
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
              store.state.editInvoice.invoiceItem.forEach((item) {
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
                updateInvoiceItems(context, selectedItems);
              },
              buttonText: Text(
                "Update Invoice Items",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }
  updateInvoiceItems(context, List<Item> items) {
    final invoiceItems = StoreProvider.of<AppState>(context);
    invoiceItems.dispatch(EditInvoiceItems(payload: items));
    Navigator.pop(context);
  }
}
