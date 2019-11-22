import 'package:akount_books/Api/BusinessPage/create_item.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utilities/svg_files.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final Widget addItem = new SvgPicture.asset(
    SVGFiles.add_item,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );
  List<bool> inputs = new List<bool>();
  List<Item> businessItems = [];

    @override
    void initState() {
    // TODO: implement initState
    setState(() {
      for (int i = 0; i < 2000; i++) {
        inputs.add(false);
      }
    });
  }

  void ItemChange(bool val, int index) {
    setState(() {
      inputs[index] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Select Items")),
        body: StoreConnector<AppState, AppState>(
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
                            icon: Icon(
                              Icons.account_box,
                              color: Theme.of(context).primaryColor,
                            ),
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
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: ListView.builder(
                                itemCount: businessItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4.0, bottom: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: ItemCard(
                                                      item: businessItems[
                                                          index])),
                                              Checkbox(
                                                  value: inputs[index],
                                                  onChanged: (bool val) {
                                                    ItemChange(val, index);
                                                  })
                                            ],
                                          )),
                                    ),
                                    onTap: () {
                                      addItemsToInvoice(
                                          businessItems[index], context);
                                    },
                                  );
                                }),
                          ),
                        ),
                      ],
                    ));
              }
            }));
  }

  addItemsToInvoice(Item item, context) {
    final invoiceCustomerProvider = StoreProvider.of<AppState>(context);
//    invoiceCustomerProvider.dispatch(AddInvoiceItems(payload: item));
    Navigator.pop(context);
  }
}
