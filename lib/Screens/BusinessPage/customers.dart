import 'package:akount_books/Api/BusinessPage/create_customer.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StoreConnector<AppState, AppState>(
          builder: (context, state) {
            List<Customer> businessCustomers = state.businessCustomers;
            if (businessCustomers.length == 0) {
              return Container(
                child: Center(
                  child: Text("No Customers"),
                ),
              );
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: businessCustomers.length,
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
                                              backgroundColor: Color.fromRGBO(
                                                  200, 228, 253, 0.4),
                                              child: Icon(
                                                Icons.business,
                                                color: Colors.blueGrey,
                                                size: 25,
                                              ))),
                                      Expanded(
                                          child: Text(
                                        businessCustomers[index].name,
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
                MaterialPageRoute(builder: (context) => AddCustomer()),
              );
            }));
  }
}
