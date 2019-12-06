import 'package:akount_books/Api/BusinessPage/update_invoice.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/edit_invoice.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Screens/UserPage/dasboard.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';

final Widget svg = new SvgPicture.asset(
  SVGFiles.success_icon,
  semanticsLabel: 'Akount-book',
  allowDrawingOutsideViewBox: true,
);
class DraftSaved extends StatelessWidget {
  final Invoice invoice;
  final List<Item> invoiceItem;
  final Customer customer;

  const DraftSaved(
      {@required this.invoice,
      @required this.invoiceItem,
      @required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: StoreConnector<AppState, AppState>(
          converter: (store)=>store.state,
            builder: (context, state) {
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
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            "You have successfully saved invoice as draft",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    PrimaryButton(
                        buttonText: Text("SEND THIS DRAFT",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        onPressed: () {
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
                          final editInvoice =
                              StoreProvider.of<AppState>(context);
                          editInvoice
                              .dispatch(AddEditInvoice(payload: _invoice));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateInvoiceData()),
                          );
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    SecondaryButton(
                        buttonText: Text("CHECK DRAFTS",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard(currentTab: 0,)),
                          );
                        }),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                        child: Text("BACK TO INVOICES PAGE",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard(currentTab: 0,)),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
