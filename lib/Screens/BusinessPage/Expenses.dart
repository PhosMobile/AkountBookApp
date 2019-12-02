import 'package:akount_books/Api/BusinessPage/create_expenses.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/Expense.dart';
import 'package:akount_books/Screens/BusinessPage/view_expense.dart';
import 'package:akount_books/Widgets/empty.dart';
import 'package:akount_books/utilities/currency_convert.dart';
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
                  child: Empty(text: "No Expenses"),
                ),
              );
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(
                          "FILTER DATE",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("All Expenses"),
                        )),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: businessExpenses.length,
                            itemBuilder: (BuildContext context, int index) {
                              Expense expense = businessExpenses[index];
                              return InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                                  color: Color.fromRGBO(248, 248, 248, 1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(child: Text(expense.name),width: MediaQuery.of(context).size.width/5,),
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  3,
                                          child: Text(
                                            expense.description,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      Container(
                                width: MediaQuery.of(context).size.width/4,
                                        child: Text(CurrencyConverter().formatPrice(
                                            int.parse(expense.price),
                                            state.currentBusiness.currency)),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ViewExpense(expense: expense, currency: state.currentBusiness.currency)),
                                  );
                                },
                              );
                            }),
                      ),
                    ),
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
