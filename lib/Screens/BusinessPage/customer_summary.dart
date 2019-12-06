import 'package:akount_books/Api/BusinessPage/create_invoice.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Widgets/empty.dart';
import 'package:akount_books/Widgets/invoice_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomerSummary extends StatefulWidget {
  final Customer customer;

  const CustomerSummary({@required this.customer});
  @override
  _CustomerSummaryState createState() => _CustomerSummaryState();
}

class _CustomerSummaryState extends State<CustomerSummary> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.customer.name, style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          actions: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  child: Text(
                    "DOWNLOAD",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                InkWell(
                  child: Icon(MdiIcons.dotsVertical),
                  onTap: (){

                  },
                )
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: InkWell(
                      child: Text("FILTER DATE", style: TextStyle(
                        color: Theme.of(context).primaryColor
                      ),),
                    ),
                  ),
                ),
              ),
              Container(
                color: Color.fromRGBO(233, 237, 240, 1),
                child: TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "INVOICES",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("RECEIPTS"),
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
