import 'package:akaunt/Api/BusinessPage/update_expense.dart';
import 'package:akaunt/AppState/actions/expense_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Models/Expense.dart';
import 'package:akaunt/Screens/UserPage/dasboard.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/loader_widget.dart';
import 'package:akaunt/Widgets/view_invoice_field_card.dart';
import 'package:akaunt/utilities/currency_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ViewExpense extends StatefulWidget {
    final Expense expense;
  final String currency;

  ViewExpense({@required this.expense, @required this.currency});
  @override
  _ViewExpenseState createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Expense Preview", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: StoreConnector<AppState, AppState>(
            converter: (store)=>store.state,
            builder: (context, state){
             var amount =  int.parse(widget.expense.price)*widget.expense.quantity;
              return Container(
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
                        Expanded(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                ViewInvoiceFieldCard(
                                    title: "Expense Name:", value: widget.expense.name),
                                ViewInvoiceFieldCard(
                                    title: "Description:", value: widget.expense.description),
                                ViewInvoiceFieldCard(title: "Date:", value: widget.expense.date,),
                                ViewInvoiceFieldCard(
                                    title: "Quantity:", value: widget.expense.quantity.toString()),
                                ViewInvoiceFieldCard(title: "Amount", value: CurrencyConverter().formatPrice(amount, state.currentBusiness.currency)),
                              ],
                            ),
                          ),
                        ),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateExpense(expense: widget.expense,)),
                                );
                              },
                            ),
                            DeleteMiniButton(
                              buttonText: _isLoading
                                  ? LoaderLight()
                                  : Text("DELETE EXPENSE",
                                  style: TextStyle(
                                      fontSize: 16, color: Color.fromRGBO(133, 2, 2, 1))),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                final store = StoreProvider.of<AppState>(context);
                                GqlConfig graphQLConfiguration = GqlConfig();
                                Mutations deleteExpense = new Mutations();
                                print(widget.expense.id);
                                QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
                                    MutationOptions(
                                        document: deleteExpense.deleteExpense(
                                            widget.expense.id
                                        )));
                                if(result.hasErrors){
                                }else{
                                  dynamic expense = result.data["delete_expense"];
                                  Expense newExpense = Expense(
                                      expense["id"],
                                      expense["name"],
                                      expense["description"],
                                      int.parse(expense["quantity"]),
                                      expense["price"],
                                      expense["date"],
                                      expense["business_id"],
                                      expense["user_id"]);
                                  store.dispatch(DeleteExpense(payload:newExpense));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard(currentTab: 2,)),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ));
  }
}
