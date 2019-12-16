import 'package:akount_books/AppState/actions/expense_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/Expense.dart';
import 'package:akount_books/Screens/UserPage/dasboard.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateExpense extends StatefulWidget {
  final Expense expense;
  const UpdateExpense({@required this.expense}) ;

  @override
  _UpdateExpenseState createState() => _UpdateExpenseState();
}

class _UpdateExpenseState extends State<UpdateExpense> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  String phone;
  String email;
  TextEditingController _expenseName = new TextEditingController();
  TextEditingController _quantity = new TextEditingController();
  TextEditingController _expenseDescription = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  String currency = "NGN";
  String expenseDate = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Update Expense")),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0),
          child: StoreConnector<AppState, AppState>(
            converter: (store)=> store.state,
            onInitialBuild: (state){
              _expenseName.text = widget.expense.name;
              _quantity.text = widget.expense.quantity.toString();
              _expenseDescription.text = widget.expense.description;
              _price.text = widget.expense.price;

              setState(() {
                expenseDate = widget.expense.date;
              });

            },
            builder: (context, state){
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 2, color: Theme.of(context).accentColor))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FormBuilder(
                                key: _fbKey,
                                initialValue: {
                                  'date': DateTime.now(),
                                  'accept_terms': false,
                                },
                                autovalidate: false,
                                child: Column(
                                  children: <Widget>[
                                    _hasErrors
                                        ? RequestError(errorText: requestErrors)
                                        : Container(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          inputStyles.boxShadowMain(context)
                                        ]),
                                        child: FormBuilderTextField(
                                          attribute: "expense_name",
                                          decoration:
                                          inputStyles.inputMain("Expense Name"),
                                          validators: [
                                            FormBuilderValidators.required()
                                          ],
                                          controller: _expenseName,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width / 2 -
                                              50,
                                          decoration: BoxDecoration(boxShadow: [
                                            inputStyles.boxShadowMain(context)
                                          ]),
                                          child: FormBuilderTextField(
                                            keyboardType: TextInputType.number,
                                            attribute: "quantity",
                                            decoration:
                                            inputStyles.inputMain("Quantity"),
                                            validators: [
                                              FormBuilderValidators.required()
                                            ],
                                            controller: _quantity,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width / 2 -
                                              50,
                                          decoration: BoxDecoration(boxShadow: [
                                            inputStyles.boxShadowMain(context)
                                          ]),
                                          child: FormBuilderTextField(
                                            keyboardType: TextInputType.number,
                                            attribute: "price",
                                            decoration: inputStyles.inputMain("Price"),
                                            validators: [
                                              FormBuilderValidators.required()
                                            ],
                                            controller: _price,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          inputStyles.boxShadowMain(context)
                                        ]),
                                        child: FormBuilderTextField(
                                          attribute: "Description",
                                          decoration:
                                          inputStyles.inputMain("Description"),
                                          validators: [
                                            FormBuilderValidators.min(30,
                                                errorText:
                                                "Business can not be short than 30 character"),
                                            FormBuilderValidators.required()
                                          ],
                                          controller: _expenseDescription,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DatePickerButtonLarge(
                                  onPressed: () {
                                    _pickExpenseDate();
                                  },
                                  buttonText: Text(
                                      expenseDate == "" ? "Payment Date" : expenseDate,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor)),
                                  icon: pickDate),
                              SizedBox(
                                height: 40,
                              ),
                              PrimaryButton(
                                buttonText: _isLoading
                                    ? LoaderLight()
                                    : Text("UPDATE EXPENSE",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                                onPressed: () {
                                  if (_fbKey.currentState.saveAndValidate()) {
                                    _saveExpense(context);
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  _saveExpense(context) async {
    GqlConfig graphQLConfiguration = GqlConfig();
    final store = StoreProvider.of<AppState>(context);
    setState(() {
      _isLoading = true;
    });
    Mutations updateExpense = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
        MutationOptions(
            document: updateExpense.updateExpense(
                widget.expense.id,
                _expenseName.text,
                _expenseDescription.text,
                int.parse(_quantity.text),
                int.parse(_price.text),
                expenseDate)));

    if(result.hasErrors){
      print(result.errors);
    }else{
      dynamic expense = result.data["update_expense"];
      Expense newExpense = Expense(
          expense["id"],
          expense["name"],
          expense["description"],
          int.parse(expense["quantity"]),
          expense["price"],
          expense["date"],
          expense["business_id"],
          expense["user_id"]);
      store.dispatch(EditExpense(payload:newExpense));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(currentTab: 2,)),
      );
    }
  }

  _pickExpenseDate() {
    var maxTime = DateTime.now().year + 10;
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(maxTime, 6, 7),
        onChanged: (date) {}, onConfirm: (date) {
          String day = date.day.toString();
          String month = date.month.toString();
          String year = date.year.toString();

          setState(() {
            expenseDate = "$year-$month-$day";
          });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
  final Widget pickDate = new SvgPicture.asset(
    SVGFiles.pick_date,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );
}
