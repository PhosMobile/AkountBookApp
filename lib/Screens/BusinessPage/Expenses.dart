import 'package:akount_books/Api/BusinessPage/create_expenses.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StoreConnector<AppState, AppState>(
          builder: (context, state) {
            List<Expense> businessExpenses = state.businessExpenses;
            if (businessExpenses.length == 0) {
              return Container(
                child: Center(
                  child: Text("No Expenses"),
                ),
              );
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: businessExpenses.length,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              child: Card(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 +
                                                  50,
                                              child: Text(
                                                businessExpenses[index].name,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ),
                                            elevation: 0.0,
                                          )),
                                          Container(
                                              child: Card(
                                            child: Container(
                                              child: RaisedButton(
                                                  color: Colors.lightGreen,
                                                  child: Text(
                                                      businessExpenses[index]
                                                          .price),
                                                  onPressed: () {}),
                                            ),
                                            elevation: 0.0,
                                          ))
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                              child: Card(
                                            child: Container(
                                              child: Text(
                                                businessExpenses[index]
                                                    .date
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ),
                                            elevation: 0.0,
                                          )),
                                          Container(
                                              child: Card(
                                            child: Container(
                                              child: Text(
                                                  businessExpenses[index]
                                                      .quantity
                                                      .toString()),
                                            ),
                                            elevation: 0.0,
                                          )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
          converter: (store) => store.state,
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add),
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpenses()),
              );
            }));
  }
}