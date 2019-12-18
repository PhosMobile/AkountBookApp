import 'package:akaunt/Api/BusinessPage/create_invoice.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Widgets/empty.dart';
import 'package:akaunt/Widgets/invoice_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Invoices extends StatefulWidget {
  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Color.fromRGBO(233, 237, 240, 1),
                child: TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "SENT",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("DRAFT"),
                      )
                    ]),
              ),
              StoreConnector<AppState, AppState>(
                builder: (context, state) {
                  List<Invoice> businessInvoice = state.businessInvoices;
                  List<Invoice> draftInvoice =
                      Invoice.draftInvoices(businessInvoice);
                  List<Invoice> sentInvoice =
                      Invoice.sentInvoices(businessInvoice);
                    return Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: TabBarView(
                              children: [
                                sentInvoice.length != 0? InvoiceListBuilder(invoices: sentInvoice, draft:false):Container(
                                child: Center(
                                child: Empty(text: "No Sent Invoice"),
                              ),
                              ),
                                draftInvoice.length != 0 ? InvoiceListBuilder(invoices: draftInvoice, draft:true):Container(
                                  child: Center(
                                    child:  Empty(text: "No Draft Invoice"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                },
                converter: (store) => store.state,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add),
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddInvoice()),
              );
            }),
      ),
    );
  }
}
