import 'package:akount_books/Api/BusinessPage/update_draft.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/edit_invoice.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/view_invoice_field_card.dart';
import 'package:akount_books/utilities/currency_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ViewInvoiceDraft extends StatelessWidget {
  final Invoice invoice;
  final Customer customer;
  final List<Item> invoiceItem;
  final String currency;

  ViewInvoiceDraft(
      {@required this.invoice,
      @required this.customer,
      @required this.invoiceItem,
      @required this.currency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Draft Preview", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          actions: <Widget>[
            InkWell(
              child: Icon(MdiIcons.dotsVertical),
              onTap: () {
                editAndSendDraft(context);
              },
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
                              title: "Invoice Name:", value: invoice.title),
                          ViewInvoiceFieldCard(
                              title: "Invoice Date:", value: invoice.issueDate),
                          ViewInvoiceFieldCard(
                              title: "Due Date:", value: invoice.dueDate),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 5),
                            color: Theme.of(context).accentColor,
                            child: Row(
                              children: <Widget>[
                                Text("Items: "),
                              ],
                            ),
                          ),
                          for (var item in invoiceItem)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ViewInvoiceFieldCard(
                                      title: "Item Name:", value: item.name),
                                  ViewInvoiceFieldCard(
                                      title: "Quantity:", value: item.quantity),
                                  ViewInvoiceFieldCard(
                                      title: "Price Per Quantity",
                                      value: CurrencyConverter().formatPrice(
                                          int.parse(item.price), "NGN")),
                                ],
                              ),
                              padding: EdgeInsets.only(
                                left: 5,
                                top: 20,
                                bottom: 20,
                              ),
                            ),
                          ViewInvoiceFieldCard(
                              title: "Amount Due",
                              value: CurrencyConverter()
                                  .formatPrice(invoice.totalAmount, "NGN")),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              PrimaryButton(
                                buttonText: Text("SEND DRAFT ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 14,
                                        color: Colors.white)),
                                onPressed: () {
                                  editAndSendDraft(context);
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

  editAndSendDraft(context){
    EditInvoice _invoice = EditInvoice(
        invoice.id,
        invoice.title,
        invoice.number,
        invoice.poSoNumber,
        invoice.summary,
        invoice.issueDate,
        invoice.dueDate,
        invoice.subTotalAmount,
        invoice.totalAmount,
        invoice.notes,
        invoice.status,
        invoice.footer,
        invoice.customerId,
        invoice.businessId,
        invoice.userId,
        invoiceItem,
        customer);
    final editInvoice = StoreProvider.of<AppState>(context);
    editInvoice.dispatch(AddEditInvoice(payload: _invoice));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateDraft()),
    );
  }
}
