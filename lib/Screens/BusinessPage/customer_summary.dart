import 'package:akaunt/Api/BusinessPage/create_invoice.dart';
import 'package:akaunt/Api/BusinessPage/record_payment.dart';
import 'package:akaunt/Api/BusinessPage/update_customer.dart';
import 'package:akaunt/AppState/actions/customer_actions.dart';
import 'package:akaunt/AppState/actions/invoice_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:akaunt/Widgets/ReceiptListBuilder.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/empty.dart';
import 'package:akaunt/Widgets/invoice_list_builder.dart';
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
          title:
              Text(widget.customer.name, style: TextStyle(color: Colors.black)),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateCustomer(customer: widget.customer,)),
                    );
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
                      child: Text(
                        "FILTER DATE",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
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
                  List<Receipt> businessReceipts = state.businessReceipts;
                  List<Receipt> allCustomerReceipts = [];
                  List<Invoice> customerInvoices = Invoice.customerInvoices(
                      businessInvoice, widget.customer.id);
                  customerInvoices.forEach((invoice) {
                    List<Receipt> invoiceReceipts =
                        Receipt.customerReceipts(businessReceipts, invoice.id);
                    invoiceReceipts.forEach((invoice) {
                      allCustomerReceipts.add(invoice);
                    });
                  });
                  return Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: TabBarView(
                            children: [
                              Column(
                                children: <Widget>[
                                  Expanded(
                                    child: customerInvoices.length != 0
                                        ? InvoiceListBuilder(
                                            invoices: customerInvoices,
                                            draft: false)
                                        : Container(
                                            child: Center(
                                              child: Empty(
                                                  text:
                                                      "No Invoice for ${widget.customer.name}"),
                                            ),
                                          ),
                                  ),
                                  Container(
                                    child: PrimaryButton(
                                        buttonText: Text(
                                          "ADD NEW INVOICE",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          StoreProvider.of<AppState>(context)
                                              .dispatch(AddInvoiceCustomer(
                                              payload: widget.customer));
                                          StoreProvider.of<AppState>(context)
                                              .dispatch(CreateInvoice(
                                              payload: null));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddInvoice()),
                                          );
                                        }),
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  SizedBox(height: 18)
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Expanded(
                                      child: allCustomerReceipts.length != 0
                                          ? ReceiptListBuilder(
                                              receipts: allCustomerReceipts,
                                              draft: true,
                                              customer: widget.customer)
                                          : Container(
                                              child: Center(
                                                child: Empty(
                                                    text:
                                                        "No Receipt for ${widget.customer.name}"),
                                              ),
                                            )),
                                  Container(
                                    child: PrimaryButton(
                                        buttonText: Text(
                                          "SEND RECEIPT",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          StoreProvider.of<AppState>(context)
                                              .dispatch(AddInvoiceCustomer(
                                                  payload: widget.customer));
                                          StoreProvider.of<AppState>(context)
                                              .dispatch(AddNameInvoice(
                                                  payload: null));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RecordPayment()),
                                          );
                                        }),
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  SizedBox(height: 18)
                                ],
                              ),
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
      ),
    );
  }
}
