import 'package:akount_books/Api/BusinessPage/create_invoice.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Screens/UserPage/dasboard.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:akount_books/AppState/actions/customer_actions.dart' as customerAction;

final Widget svg = new SvgPicture.asset(
  SVGFiles.success_icon,
  semanticsLabel: 'Akount-book',
  allowDrawingOutsideViewBox: true,
);

class CustomerCreated extends StatelessWidget {
  final Customer customer;

  const CustomerCreated({@required this.customer});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pushNamed(context, "/user_dashboard");
            },
          ),
        ),
        body: StoreConnector<AppState, AppState>(
          converter: (store)=>store.state,
          builder: (context, state){
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: Theme.of(context).accentColor))),
              child: new Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          svg,
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              "You have successfully added a \n customer to list",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      PrimaryButton(
                          buttonText: Text("SEND INVOICE TO CUSTOMER",
                              style: TextStyle(fontSize: 16, color: Colors.white)),
                          onPressed: () {
                            final invoiceCustomerProvider = StoreProvider.of<AppState>(context);
                            invoiceCustomerProvider.dispatch(customerAction.AddInvoiceCustomer(payload: customer));
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddInvoice()),
                            );
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      CancelButton(
                          buttonText: Text("BACK TO CUSTOMERS PAGE CUSTOMER",
                              style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard(currentTab: 1,)),
                            );
                          })
                    ],
                  ),
                ),
              ),
            );
          }
        ));
  }
}
