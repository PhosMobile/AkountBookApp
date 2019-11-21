import 'package:akount_books/Api/BusinessPage/create_item.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Select Customer")),
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
                        Divider(),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: ListView.builder(
                                itemCount: businessItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 3,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              style: BorderStyle.solid)),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15.0),
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          200, 228, 253, 0.4),
                                                  child: Icon(
                                                    Icons.business,
                                                    color: Colors.blueGrey,
                                                    size: 25,
                                                  ))),
                                          Expanded(
                                              child: Text(
                                            businessItems[index].name,
                                            style: TextStyle(
                                                color: Colors.blueGrey[20]),
                                          )),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ));
              }
            }));
  }
}
