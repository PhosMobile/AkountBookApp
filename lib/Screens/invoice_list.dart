import 'package:akount_books/Api/BusinessPage/attach_new_invoice.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/currency_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InvoiceList extends StatefulWidget {
  @override
  _InvoiceListState createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: HeaderTitle(headerText: "Select Invoice"),elevation: 0,),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  child: ChooseButton(
                    buttonText: Text(
                      "Attach New Invoice",
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
                            builder: (context) => AttachNewInvoice()),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height:20,),
              StoreConnector<AppState, AppState>(
                builder: (context, state) {
                  List<Invoice> businessInvoice = state.businessInvoices;
                  String currency = state.currentBusiness.currency;
                  return Container(
                    height: MediaQuery.of(context).size.height-160,
                    padding: EdgeInsets.only(bottom: 40),
                    child: ListView.builder(
                              itemCount: businessInvoice.length,
                              itemBuilder: (BuildContext context, int index) {
                                String cName;
                                String invoiceTitle = businessInvoice[index].title;
                                Invoice invoice = businessInvoice[index];
                                Customer invoiceCustomer = Invoice.getInvoiceCustomer(
                                    businessInvoice[index].customerId, state.businessCustomers);
                                if (invoiceCustomer != null) {
                                  cName = invoiceCustomer.name;
                                }
                                return InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(20.0),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(248, 248, 248, 1),
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 2,
                                                color: Color.fromRGBO(233, 237, 240, 1)))),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("$invoiceTitle > $cName"),
                                            Text(
                                              CurrencyConverter()
                                                  .formatPrice(invoice.totalAmount, currency),
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 7, bottom: 7, left: 15, right: 15),
                                              decoration: BoxDecoration(
                                                  color: invoice.status == "SENT" ? Colors.green:Theme.of(context).accentColor,
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(3))),
                                              child: Text(
                                                invoice.status,
                                                style: TextStyle(
                                                    color: invoice.status == "SENT" ? Colors.white:Theme.of(context).primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Text(invoice.dueDate)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                  StoreProvider.of<AppState>(context).dispatch(CreateInvoice(payload: invoice));
                                  Navigator.pop(context);
                                },
                                );
                              }),
                  );

                },
                converter: (store) => store.state,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
