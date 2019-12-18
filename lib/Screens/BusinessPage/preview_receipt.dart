import 'package:akaunt/Api/BusinessPage/send_receipt.dart';
import 'package:akaunt/AppState/actions/receipt_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/loading_snack_bar.dart';
import 'package:akaunt/Widgets/view_invoice_field_card.dart';
import 'package:akaunt/utilities/currency_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ReceiptPreview extends StatelessWidget {
  final Receipt receipt;
  final Customer customer;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ReceiptPreview(
      {@required this.receipt,
        @required this.customer,
        });
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text("Confirm Payment", style: TextStyle(color: Colors.black)),
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
              ],
            )
          ],
        ),
        body: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 2, color: Theme.of(context).accentColor))),
                  child: new Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ViewInvoiceFieldCard(
                              title: "Customer Name:", value: customer.name),
                          ViewInvoiceFieldCard(
                              title: "Receipt Name:", value: receipt.name),
                          ViewInvoiceFieldCard(
                              title: "Payment Date:", value: receipt.paymentDate),
                          ViewInvoiceFieldCard(
                              title: "Payment Type:", value: receipt.paymentType),
                          ViewInvoiceFieldCard(
                              title: "Payment Method:", value: receipt.paymentMethod),
                          ViewInvoiceFieldCard(
                              title: "Amount Paid:", value: CurrencyConverter().formatPrice(int.parse(receipt.amountPaid), state.currentBusiness.currency)),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              PrimaryMiniButton(
                                buttonText: Text("SEND RECEIPT",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 14,
                                        color: Colors.white)),
                                onPressed: () {
                                  _sendInvoice(context,receipt,customer);
                                },
                              ),
                              SecondaryMiniButton(
                                buttonText: Text("EDIT RECEIPT",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor)),
                                onPressed: () {
                                    Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  _sendInvoice(context, Receipt receipt, Customer customer) async {
    _scaffoldKey.currentState.showSnackBar(LoadingSnackBar()
        .loaderHigh("  Saving Receipt...", context));

    final addReceipt = StoreProvider.of<AppState>(context);
    final _state = addReceipt.state;
    GqlConfig graphQLConfiguration = GqlConfig();

    Mutations createReceipt = new Mutations();
    QueryResult receiptResult =
    await graphQLConfiguration.getGraphql(context).mutate(MutationOptions(
        document: createReceipt.createReceipt(
            receipt.name,
            int.parse(receipt.amountPaid),
            receipt.paymentDate,
            receipt.paymentMethod,
            receipt.paymentType,
            "done",
            _state.readyInvoice.id,
            _state.currentBusiness.id,
            customer.id,
            _state.loggedInUser.userId)));
    if (receiptResult.hasErrors) {
      print(receiptResult.errors);
    } else {
      dynamic _receiptDataBody = receiptResult.data["create_receipt"];
      Receipt _receiptQueryData = new Receipt(
          _receiptDataBody["id"],
          _receiptDataBody["name"],
          _receiptDataBody["amount_paid"],
          _receiptDataBody["payment_date"],
          _receiptDataBody["payment_method"],
          _receiptDataBody["payment_type"],
          _receiptDataBody["status"],
          _receiptDataBody["invoice_id"],
          _receiptDataBody["busines_id"],
          _receiptDataBody["customer_id"],
          _receiptDataBody["user_id"]
      );
      addReceipt.dispatch(UpdateInvoiceReceipts(payload: _receiptQueryData));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SendReceipt()),
      );
    }
  }
}
