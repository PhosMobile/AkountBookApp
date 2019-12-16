import 'package:akount_books/Api/BusinessPage/create_customer.dart';
import 'package:akount_books/AppState/actions/customer_actions.dart' as customerAction;
import 'package:akount_books/AppState/actions/user_phone_contacts_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utilities/svg_files.dart';

class ContactList extends StatelessWidget {


  final Widget addCustomer = new SvgPicture.asset(
    SVGFiles.add_customer,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: HeaderTitle(headerText: "Select Contact"),elevation: 0,),
        body: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
          ),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                List<Customer> businessCustomers = state.businessCustomers;
                if (businessCustomers.length == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text("No Customers"),
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
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
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
                            ),
                          ),
                        ],
                      ));
                }
              }),
        ));
  }
  addCustomerToInvoice(Customer customer, context){
    final invoiceCustomerProvider = StoreProvider.of<AppState>(context);
    invoiceCustomerProvider.dispatch(customerAction.AddInvoiceCustomer(payload: customer));
    Navigator.pop(context);
  }

}


