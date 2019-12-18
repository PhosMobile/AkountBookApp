import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:akaunt/utilities/currency_convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ReceiptListBuilder extends StatelessWidget {
  final List<Receipt> receipts;
  final bool draft;
  final Customer customer;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ReceiptListBuilder({@required this.receipts, @required this.draft, @required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            String currency = state.currentBusiness.currency;
            return ListView.builder(
                itemCount: receipts.length,
                itemBuilder: (BuildContext context, int index) {
                  Receipt receipt = receipts[index];
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
                              Text("${receipt.name} > ${customer.name}"),
                              Text(
                                CurrencyConverter()
                                    .formatPrice(int.parse(receipt.amountPaid), currency),
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
                                    top: 5, bottom: 5, left: 15, right: 15),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                                child: Text(
                                  receipt.status,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              Text(receipt.paymentDate)
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
//                      List<Item> allInvoiceItems = [];
//                      _scaffoldKey.currentState.showSnackBar(LoadingSnackBar()
//                          .loaderHigh("  Getting Invoice Data...", context));
//                      List<dynamic> invoiceItems = await GetInvoiceItems()
//                          .fetchInvoiceItems(receipt.id, context);
//                      if (invoiceItems == null) {
//                      } else {
//                        for (var item in invoiceItems) {
//                          state.businessItems.forEach((businessItem) {
//                            if (item["item_id"] == businessItem.id) {
//                              allInvoiceItems.add(businessItem);
//                            }
//                          });
//                        }
//                      }
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => draft
//                                ? ViewInvoiceDraft(
//                                invoice: invoice,
//                                customer: invoiceCustomer,
//                                invoiceItem: allInvoiceItems,
//                                currency: currency)
//                                : ViewInvoice(
//                                invoice: invoice,
//                                customer: invoiceCustomer,
//                                invoiceItem: allInvoiceItems,
//                                currency: currency)),
//                      );
                    },
                  );
                });
          }),
    );
  }
}
