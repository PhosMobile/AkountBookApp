import 'package:akaunt/Api/BusinessPage/create_customer.dart';
import 'package:akaunt/AppState/actions/customer_actions.dart' as customerAction;
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Widgets/HeaderTitle.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/customer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utilities/svg_files.dart';

class AddCustomerList extends StatelessWidget {


  final Widget addCustomer = new SvgPicture.asset(
    SVGFiles.add_customer,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Select Customer"),elevation: 0,),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            child: ChooseButton(
                              buttonText: Text(
                                "Add Customer",
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
                                      builder: (context) => AddCustomer(direct: false,)),
                                );
                              },
                            ),
                          ),
                        ),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              child: ChooseButton(
                                buttonText: Text(
                                  "Add Customer",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                icon: addCustomer,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddCustomer(direct: false,)),
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
                                  itemCount: businessCustomers.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:4.0,bottom: 4.0),
                                        child: CustomerCard(customer: businessCustomers[index])
                                      ),
                                      onTap: (){
                                          addCustomerToInvoice(businessCustomers[index], context);
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


