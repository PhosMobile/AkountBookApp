import 'package:akaunt/Api/BusinessPage/create_customer.dart';
import 'package:akaunt/AppState/actions/user_phone_contacts_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Screens/BusinessPage/customer_summary.dart';
import 'package:akaunt/Widgets/customer_card.dart';
import 'package:akaunt/Widgets/empty.dart';
import 'package:akaunt/utilities/svg_files.dart';
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
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: StoreConnector<AppState, AppState>(
            builder: (context, state) {
              List<Customer> businessCustomers = state.businessCustomers;
              if (businessCustomers.length == 0) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Empty(text: "No Customer"),
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            itemCount: businessCustomers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, bottom: 4.0),
                                    child: CustomerCard(
                                        customer: businessCustomers[index])),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CustomerSummary(
                                            customer:
                                            businessCustomers[index])),
                                  );
                                },
                              );
                            }),
                      ),
                      Container(
                        color: Theme.of(context).accentColor,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 15,bottom: 15, left: 30),
                        child: Text("Phone Contacts", style: TextStyle(color: Theme.of(context).primaryColor)),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: state.userContacts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, bottom: 4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:  Color.fromRGBO(248, 248, 248, 1)
                                      ),
                                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:20.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15.0),
                                                child: (state.userContacts[index].avatar != null && state.userContacts[index].avatar.length > 0)
                                                    ? CircleAvatar(
                                                  backgroundImage: MemoryImage(state.userContacts[index].avatar),
                                                )
                                                    : CircleAvatar(child: Text(state.userContacts[index].displayName[0].toUpperCase()))),
                                            Expanded(
                                                child: Text(
                                                  state.userContacts[index].displayName,
                                                  style: TextStyle(
                                                      color: Colors.blueGrey[20]),
                                                )),
                                          ],
                                        ),
                                      ),
                                    )),
                                onTap: () {
                                  final contact = StoreProvider.of<AppState>(context);
                                  contact.dispatch(AddCustomerFromContact(payload: state.userContacts[index]));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddCustomer(direct: true), ),
                                  );
                                },
                              );
                            }),
                      )
                    ],
                  ),
                );
              }
            },
            converter: (store) => store.state,
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add),
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddCustomer(
                          direct: true,
                        )),
              );
            }));
  }
}
