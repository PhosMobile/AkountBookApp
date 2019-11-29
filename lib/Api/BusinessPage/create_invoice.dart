import 'package:akount_books/Api/BusinessPage/InvoiceItems.dart';
import 'package:akount_books/Api/BusinessPage/create_expenses.dart';
import 'package:akount_books/Api/BusinessPage/send_invoice.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/invoice_name.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Screens/BusinessPage/customers_list.dart';
import 'package:akount_books/Api/BusinessPage/add_invoice_name.dart';
import 'package:akount_books/Screens/BusinessPage/draft_saved.dart';
import 'package:akount_books/Screens/BusinessPage/item_list.dart';
import 'package:akount_books/Widgets/AlertSnackBar.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/invoice_item_card.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/current_date.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../AppState/app_state.dart';

class AddInvoice extends StatefulWidget {
  @override
  _AddInvoiceState createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  InputStyles inputStyles = new InputStyles();
  String requestErrors;
  bool _isDraftLoading = false;
  bool _isSendLoading = false;

  bool _hasErrors = false;
  TextEditingController _subTotal = new TextEditingController();
  TextEditingController _total = new TextEditingController();
  TextEditingController _notes = new TextEditingController();
  TextEditingController _footer = new TextEditingController();
  String invoiceDate = "";
  String dueDate = "";

  String _invoiceName = "INVOICE NAME";
  String _invoiceType = "DRAFT";
  String _invoiceDescription = "Project Name / Description";
  String _invoiceNumber = "P.S/S.O Number";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldState,
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Create Invoice")),
        body: SingleChildScrollView(
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                InvoiceName invoiceNameData = state.invoiceName;
                String businessId = state.currentBusiness.id;
                String userId = state.loggedInUser.user_id;

                if (state.invoiceName != null) {
                  _invoiceName = invoiceNameData.title;
                  _invoiceDescription = invoiceNameData.summary;
                  _invoiceNumber = invoiceNameData.po_so_number;
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 0, left: 20, right: 20),
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
                                InkWell(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .accentColor)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    child: Card(
                                                  child: Container(
                                                    child: Text(
                                                      _invoiceName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                  elevation: 0.0,
                                                )),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Card(
                                                      child: Container(
                                                        child: Text(
                                                            _invoiceDescription,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            )),
                                                      ),
                                                      elevation: 0.0,
                                                    ))
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                    child: Card(
                                                  child: Container(
                                                    child: Text(
                                                      _invoiceType,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  elevation: 0.0,
                                                )),
                                                Container(
                                                    child: Card(
                                                  child: Container(
                                                    child: Text(_invoiceNumber),
                                                  ),
                                                  elevation: 0.0,
                                                )),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddInvoiceName()),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    DatePickerButton(
                                        onPressed: () {
                                          _pickInvoiceDate();
                                        },
                                        buttonText: Text(
                                            invoiceDate == ""
                                                ? "Invoice Date"
                                                : invoiceDate,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        icon: pickDate),
                                    DatePickerButton(
                                        onPressed: () {
                                          _pickDueDate();
                                        },
                                        buttonText: Text(
                                            dueDate == ""
                                                ? "Due Date"
                                                : dueDate,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        icon: pickDate)
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        inputStyles.boxShadowMain(context)
                                      ]),
                                      child: ChooseButton(
                                        buttonText: Text(
                                          state.invoiceCustomer == null
                                              ? "Add Customer"
                                              : state.invoiceCustomer.name,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        icon: addCustomer,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerList()),
                                          );
                                        },
                                      )),
                                ),
                                state.invoiceItems.length != 0
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                bottom: 10.0, top: 10.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                    state.invoiceItems.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                                Text(
                                                  " Item(s) Added",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3.0,
                                          ),
                                          // ignore: sdk_version_ui_as_code
                                          for (var item in state.invoiceItems)
                                            Column(
                                              children: <Widget>[
                                                InvoiceItemCard(
                                                  item: item,
                                                  businessCurrency: state
                                                      .currentBusiness.currency,
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                              ],
                                            )
                                        ],
                                      )
                                    : SizedBox(),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      inputStyles.boxShadowMain(context)
                                    ]),
                                    child: ChooseButton(
                                      buttonText: Text(
                                        "Add Items",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      icon: addItem,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ItemList()),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          50,
                                      decoration: BoxDecoration(boxShadow: [
                                        inputStyles.boxShadowMain(context)
                                      ]),
                                      child: FormBuilderTextField(
                                        keyboardType: TextInputType.number,
                                        attribute: "sub_total",
                                        decoration:
                                            inputStyles.inputMain("Sub Total"),
                                        validators: [
                                          FormBuilderValidators.required(),
                                          FormBuilderValidators.numeric()
                                        ],
                                        controller: _subTotal,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          50,
                                      decoration: BoxDecoration(boxShadow: [
                                        inputStyles.boxShadowMain(context)
                                      ]),
                                      child: FormBuilderTextField(
                                        keyboardType: TextInputType.number,
                                        attribute: "total",
                                        decoration:
                                            inputStyles.inputMain("Total"),
                                        validators: [
                                          FormBuilderValidators.required(),
                                          FormBuilderValidators.numeric()
                                        ],
                                        controller: _total,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      inputStyles.boxShadowMain(context)
                                    ]),
                                    child: FormBuilderTextField(
                                      attribute: "Notes",
                                      decoration:
                                          inputStyles.inputMain("Notes"),
                                      controller: _notes,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      inputStyles.boxShadowMain(context)
                                    ]),
                                    child: FormBuilderTextField(
                                      attribute: "Footer",
                                      decoration:
                                          inputStyles.inputMain("Footer"),
                                      controller: _footer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              PrimaryMiniButton(
                                buttonText: _isSendLoading
                                    ? LoaderLight()
                                    : Text("SEND",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontSize: 14,
                                            color: Colors.white)),
                                onPressed: () {
                                  if (_fbKey.currentState.saveAndValidate()) {
                                    _saveInvoice(
                                        invoiceNameData,
                                        false,
                                        businessId,
                                        userId,
                                        state.invoiceCustomer);
                                  }
                                },
                              ),
                              SecondaryMiniButton(
                                buttonText: _isDraftLoading
                                    ? LoaderLight()
                                    : Text("SAVE DRAFT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                onPressed: () {
                                  if (_fbKey.currentState.saveAndValidate()) {
                                    _saveInvoice(
                                        invoiceNameData,
                                        true,
                                        businessId,
                                        userId,
                                        state.invoiceCustomer);
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                    ),
                  ],
                );
              }),
        ));
  }

  _pickInvoiceDate() {
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
        invoiceDate = "$year-$month-$day";
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  _pickDueDate() {
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
        dueDate = "$year-$month-$day";
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  final Widget pickDate = new SvgPicture.asset(
    SVGFiles.pick_date,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );
  final Widget addCustomer = new SvgPicture.asset(
    SVGFiles.add_customer,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );
  final Widget addItem = new SvgPicture.asset(
    SVGFiles.add_item,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );

  void _saveInvoice(InvoiceName invoiceNameData, bool isDraft, businessId,
      userId, Customer customer) async {
    AlertSnaackBar alert = AlertSnaackBar();
    String title, poSoNumber, summary, customerId, _iDate, _dDate;
    int invoice_number;
    if (invoiceDate == "") {
      _iDate = CurrentDate().getCurrentDate();
    } else {
      _iDate = invoiceDate;
    }
    if (dueDate == "") {
      _dDate = CurrentDate().getCurrentDate();
    } else {
      _dDate = dueDate;
    }

    final addInvoice = StoreProvider.of<AppState>(context);
    List<Item> invoiceItems = addInvoice.state.invoiceItems;
    Customer invoiceCustomer = addInvoice.state.invoiceCustomer;
    InvoiceName invoiceName = addInvoice.state.invoiceName;

    String _status;
    if (customer == null) {
      customerId = null;
    } else {
      customerId = customer.id;
    }

    if (isDraft) {
      setState(() {
        _isDraftLoading = true;
      });
      _status = "DRAFT";
      if (invoiceNameData == null) {
        title = "null";
        poSoNumber = "null";
        summary = "null";
        invoice_number = 0;
      } else {
        title = invoiceNameData.title;
        poSoNumber = invoiceNameData.po_so_number;
        summary = invoiceNameData.summary;
        invoice_number = invoiceNameData.invoice_number;
      }
      GqlConfig graphQLConfiguration = GqlConfig();
      Mutations createInvoice = new Mutations();
      QueryResult result = await graphQLConfiguration.getGraphql().mutate(
          MutationOptions(
              document: createInvoice.createInvoice(
                  title,
                  invoice_number,
                  poSoNumber,
                  summary,
                  _iDate,
                  _dDate,
                  int.parse(_subTotal.text),
                  int.parse(_total.text),
                  _notes.text,
                  _status,
                  _footer.text,
                  customerId,
                  businessId,
                  userId)));
      if (!result.hasErrors) {
        InvoiceItems().saveInvoiceItems(
            addInvoice.state.invoiceItems, result.data["create_invoice"]["id"]);
        setState(() {
          _isDraftLoading = false;
          _isSendLoading = false;
        });
        Invoice _invoice = new Invoice(
            "0",
            invoiceName.title,
            invoiceName.invoice_number,
            invoiceName.po_so_number,
            invoiceName.summary,
            _iDate,
            _dDate,
            _subTotal.text,
            _total.text,
            _notes.text,
            _status,
            _footer.text,
            customerId,
            addInvoice.state.currentBusiness.id,
            userId);
        addInvoice.dispatch(AddBusinessInvoice(payload: _invoice));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DraftSaved()),
        );
      } else {
        print(result.errors);

        setState(() {
          _isDraftLoading = false;
          _isSendLoading = false;
        });
      }
    } else {
      _status = "SENT";
      if (invoiceCustomer == null) {
        scaffoldState.currentState
            .showSnackBar(alert.showSnackBar("Invoice must contain customer"));
        return;
      } else if (invoiceItems.length == 0) {
        scaffoldState.currentState.showSnackBar(
            alert.showSnackBar("No item sellected for this invoice."));
        return;
      } else if (_subTotal.text.length == 0) {
        scaffoldState.currentState.showSnackBar(
            alert.showSnackBar("Invoice Sub total cannot be empty"));
        return;
      } else if (_total.text.length == 0) {
        scaffoldState.currentState
            .showSnackBar(alert.showSnackBar("Invoice Total cannot be empty"));
        return;
      }
      Invoice _invoice = new Invoice(
          "0",
          invoiceName.title,
          invoiceName.invoice_number,
          invoiceName.po_so_number,
          invoiceName.summary,
          _iDate,
          _dDate,
          _subTotal.text,
          _total.text,
          _notes.text,
          _status,
          _footer.text,
          customerId,
          addInvoice.state.currentBusiness.id,
          userId);
      addInvoice.dispatch(CreateInvoice(payload: _invoice));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SendInvoice()),
      );
    }
  }
}
