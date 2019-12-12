import 'package:akount_books/Models/Expense.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/view_invoice_field_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewExpense extends StatelessWidget {
  final Expense expense;
  final String currency;

  ViewExpense({@required this.expense, @required this.currency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Expense Preview", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: Container(
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
                      title: "Expense Name:", value: expense.name),
                  ViewInvoiceFieldCard(
                      title: "Description:", value: expense.description),
                  ViewInvoiceFieldCard(title: "Date:", value: expense.date),
                  ViewInvoiceFieldCard(
                      title: "Quantity:", value: expense.quantity),
                  ViewInvoiceFieldCard(title: "Amount", value: expense.price),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      PrimaryMiniButton(
                        buttonText: Text("UPDATE EXPENSE ",
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 14,
                                color: Colors.white)),
                        onPressed: () {},
                      ),
                      DeleteMiniButton(
                        buttonText: Text("DELETE EXPENSE",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(133, 2, 2, 1))),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
