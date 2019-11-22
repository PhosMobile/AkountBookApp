import 'package:akount_books/Models/invoice_name.dart';
import 'package:akount_books/Screens/BusinessPage/customers_list.dart';
import 'package:akount_books/Api/BusinessPage/add_invoice_name.dart';
import 'package:akount_books/Screens/BusinessPage/item_list.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/customer_card.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';

import '../../AppState/app_state.dart';

class AddInvoice extends StatefulWidget {
  @override
  _AddInvoiceState createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  String requestErrors;
  bool _isLoading = false;
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
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Create Invoice")),
        body: SingleChildScrollView(
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                InvoiceName invoiceNameData = state.invoiceName;
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
                                          state.invoiceCustomer == null ? "Add Customer":state.invoiceCustomer.name,
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
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        icon: addItem,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemList()),
                                          );
                                        },
                                      )),
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
                                          FormBuilderValidators.required()
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
                                          FormBuilderValidators.required()
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
                                      validators: [
                                        FormBuilderValidators.required(),
                                      ],
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
                                      validators: [
                                        FormBuilderValidators.required(),
                                      ],
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
                                buttonText: _isLoading
                                    ? LoaderLight()
                                    : Text("SEND",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontSize: 14,
                                            color: Colors.white)),
                                onPressed: () {
                                  if (_fbKey.currentState.saveAndValidate()) {
                                    _saveInvoice();
                                  }
                                },
                              ),
                              SecondaryMiniButton(
                                buttonText: _isLoading
                                    ? LoaderLight()
                                    : Text("SAVE DRAFT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                onPressed: () {
                                  if (_fbKey.currentState.saveAndValidate()) {
                                    _saveInvoice();
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
    var maxTime= DateTime.now().year +10;
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(maxTime, 6, 7),
        onChanged: (date) {}, onConfirm: (date) {
      String day = date.day.toString();
      String month = date.month.toString();
      String year = date.year.toString();
      setState(() {
        invoiceDate = "$day / $month / $year";
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
  _pickDueDate() {
    var maxTime= DateTime.now().year +10;
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(maxTime, 6, 7),
        onChanged: (date) {}, onConfirm: (date) {
      String day = date.day.toString();
      String month = date.month.toString();
      String year = date.year.toString();

      setState(() {
        dueDate = "$day / $month / $year";
      });

    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void _saveInvoice() async {}

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
}
