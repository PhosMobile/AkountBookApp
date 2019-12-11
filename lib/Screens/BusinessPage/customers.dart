import 'package:akount_books/Api/BusinessPage/create_customer.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Screens/BusinessPage/customer_summary.dart';
import 'package:akount_books/Widgets/customer_card.dart';
import 'package:akount_books/Widgets/empty.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final Widget addCustomer = new SvgPicture.asset(
    SVGFiles.add_customer,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StoreConnector<AppState, AppState>(
          builder: (context, state) {
            List<Customer> businessCustomers = state.businessCustomers;
            if (businessCustomers.length == 0) {
              return Container(
                child: Center(
                  child: Empty(text: "No Customers"),
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
                              return InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(top:4.0,bottom: 4.0),
                                    child: CustomerCard(customer: businessCustomers[index])
                                ),
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CustomerSummary(customer:businessCustomers[index])),
                                  );
                                },
                              );
                            }),
                      ),
                    ),
                    SizedBox(height:80)
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
                MaterialPageRoute(builder: (context) => AddCustomer(direct: true,)),
              );
            }));
  }
}
