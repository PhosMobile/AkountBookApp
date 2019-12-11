import 'package:akount_books/Api/BusinessPage/InvoiceItems.dart';
import 'package:akount_books/Api/BusinessPage/send_invoice.dart';
import 'package:akount_books/AppState/actions/discount_actions.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/discount.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/invoice_name.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Screens/BusinessPage/add_customers_list.dart';
import 'package:akount_books/Api/BusinessPage/create_invoice_name.dart';
import 'package:akount_books/Screens/BusinessPage/draft_saved.dart';
import 'package:akount_books/Screens/BusinessPage/add_item_list.dart';
import 'package:akount_books/Widgets/AlertSnackBar.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/invoice_item_card.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/utilities/currency_convert.dart';
import 'package:akount_books/utilities/current_date.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:akount_books/utilities/total_and_sub_total.dart';
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
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  InputStyles inputStyles = new InputStyles();
  String requestErrors;
  bool _isDraftLoading = false;
  bool _isSendLoading = false;

  bool _hasErrors = false;
  TextEditingController _subTotal = new TextEditingController();
  TextEditingController _total = new TextEditingController();
  TextEditingController _notes = new TextEditingController();
  TextEditingController _footer = new TextEditingController();
  TextEditingController _discountDescription = new TextEditingController();
  TextEditingController _discountAmount = new TextEditingController();
  bool isNewInvoice = true;
  String invoiceDate = "";
  String dueDate = "";
  String _invoiceName = "INVOICE NAME";
  String _invoiceType = "DRAFT";
  String _invoiceDescription = "Project Name / Description";
  String _invoiceNumber = "P.S/S.O Number";

  List<Map<String, dynamic>> _children = [];

  int discountTax = 1;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldState,
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
                String userId = state.loggedInUser.userId;

                if (state.invoiceName != null) {
                  _invoiceName = invoiceNameData.title;
                  _invoiceDescription = invoiceNameData.summary;
                  _invoiceNumber = invoiceNameData.poSoNumber;
                }

                _subTotal.text =
                    CurrencyConverter().formatPrice(
                        TotalAndSubTotal()
                            .getSubTotal(context,isNewInvoice),
                        state.currentBusiness
                            .currency);
                _total.text = CurrencyConverter().formatPrice(calculateTotal(), state.currentBusiness
                    .currency);


                return Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 2, color: Theme.of(context).accentColor))),
                  child: Column(
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                    elevation: 0.0,
                                                  )),
                                                  Container(
                                                      child: Card(
                                                    child: Container(
                                                      child:
                                                          Text(_invoiceNumber),
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
                                                      AddCustomerList()),
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
                                                          color: Theme.of(
                                                                  context)
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
                                            for (var item in state.invoiceItems)
                                              Column(
                                                children: <Widget>[
                                                  InvoiceItemCard(
                                                    item: item,
                                                    businessCurrency: state
                                                        .currentBusiness
                                                        .currency,
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
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        icon: addItem,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddItemList()),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.add,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          Text("Add Discount / Tax",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      _add();
                                    },
                                  ),
                                  for (var item in _children)
                                    Padding(
                                     padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(child: Text(item["description"])),
                                          SizedBox(width: 10),
                                          Text(item["amount"]),
                                          SizedBox(width: 10),
                                          Container(
                                            child: item["type"] == 1
                                                ? Icon(
                                              Icons.remove,
                                              size: 12,
                                              color: Colors.white,
                                            )
                                                : Icon(
                                              Icons.add,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            padding: EdgeInsets.all(5),
                                          ),
                                          SizedBox(width: 10),
                                          InkWell(
                                            child: Container(child: Icon(Icons.delete, size: 15,
                                              color: Colors.redAccent,)),
                                            onTap: (){
                                              setState(() {
                                                _children.remove(item);
                                              });
                                            },
                                          )

                                        ],
                                      ),
                                    ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                50,
                                        decoration: BoxDecoration(boxShadow: [
                                          inputStyles.boxShadowMain(context)
                                        ]),
                                        child: FormBuilderTextField(
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          attribute: "sub_total",
                                          decoration: inputStyles.inputMain("Sub Total"),
                                          controller: _subTotal,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                50,
                                        decoration: BoxDecoration(boxShadow: [
                                          inputStyles.boxShadowMain(context)
                                        ]),
                                        child: FormBuilderTextField(
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          attribute: "total",
                                          decoration: inputStyles.inputMain("Total"),
                                          controller: _total,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
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
                  ),
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
    AlertSnackBar alert = AlertSnackBar();
    String title, poSoNumber, summary, customerId, _iDate, _dDate;
    int invoiceNumber;
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
        invoiceNumber = -1;
      } else {
        title = invoiceNameData.title;
        poSoNumber = invoiceNameData.poSoNumber;
        summary = invoiceNameData.summary;
        invoiceNumber = invoiceNameData.invoiceNumber;
      }
      GqlConfig graphQLConfiguration = GqlConfig();
      Mutations cInvoice = new Mutations();
      QueryResult result = await graphQLConfiguration
          .getGraphql(context)
          .mutate(MutationOptions(
              document: cInvoice.createInvoice(
                  title,
                  invoiceNumber,
                  poSoNumber,
                  summary,
                  _iDate,
                  _dDate,
                  TotalAndSubTotal().getSubTotal(context,isNewInvoice),
                  calculateTotal(),
                  _notes.text,
                  _status,
                  _footer.text,
                  customer != null ? customerId : "-1",
                  businessId,
                  userId)));
      if (!result.hasErrors) {
        InvoiceItems().saveInvoiceItems(addInvoice.state.invoiceItems,
            result.data["create_invoice"]["id"], context);
        setState(() {
          _isDraftLoading = false;
          _isSendLoading = false;
        });
        Invoice _invoice = new Invoice(
            result.data["create_invoice"]["id"],
            title,
            invoiceNumber,
            poSoNumber,
            summary,
            _iDate,
            _dDate,
            TotalAndSubTotal().getSubTotal(context,isNewInvoice),
            calculateTotal(),
            _notes.text,
            _status,
            _footer.text,
            customerId,
            businessId,
            userId);
        addInvoice.dispatch(AddBusinessInvoice(payload: _invoice));


        for(var discount in _children){
        QueryResult discountResult = await graphQLConfiguration
            .getGraphql(context)
            .mutate(MutationOptions(
            document: cInvoice.createDiscount(discount["description"], discount["amount"], discount["type"], result.data["create_invoice"]["id"], businessId, userId)));
        if(!discountResult.hasErrors){
          Discount _invoiceDiscount = new Discount("0", discount["description"], discount["amount"], discount["type"], addInvoice.state.currentBusiness.id,"0",addInvoice.state.loggedInUser.userId);
          addInvoice.dispatch(CreateDiscount(payload: _invoiceDiscount));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DraftSaved(
                  invoice: _invoice,
                  invoiceItem: addInvoice.state.invoiceItems,
                  customer: customer,
                )),
          );
        }else{
          print(discountResult.errors);
        }
        }

      } else {
        print(result.source);
        setState(() {
          _isDraftLoading = false;
          _isSendLoading = false;
        });
      }
    } else {
      _status = "SENT";
      if (invoiceCustomer == null) {
        _scaffoldState.currentState
            .showSnackBar(alert.showSnackBar("Invoice must contain customer"));
        return;
      } else if (invoiceItems.length == 0) {
        _scaffoldState.currentState.showSnackBar(
            alert.showSnackBar("No item sellected for this invoice."));
        return;
      } else if (_subTotal.text.length == 0) {
        _scaffoldState.currentState.showSnackBar(
            alert.showSnackBar("Invoice Sub total cannot be empty"));
        return;
      } else if (_total.text.length == 0) {
        _scaffoldState.currentState
            .showSnackBar(alert.showSnackBar("Invoice Total cannot be empty"));
        return;
      }
      Invoice _invoice = new Invoice(
          "0",
          invoiceName.title,
          invoiceName.invoiceNumber,
          invoiceName.poSoNumber,
          invoiceName.summary,
          _iDate,
          _dDate,
          TotalAndSubTotal().getSubTotal(context,isNewInvoice),
          calculateTotal(),
          _notes.text,
          _status,
          _footer.text,
          customerId,
          addInvoice.state.currentBusiness.id,
          userId);
      addInvoice.dispatch(CreateInvoice(payload: _invoice));

      for(var discount in _children){
        Discount _invoiceDiscount = new Discount("0", discount["description"], discount["amount"], discount["type"], addInvoice.state.currentBusiness.id,"0",addInvoice.state.loggedInUser.userId);
        addInvoice.dispatch(CreateDiscount(payload: _invoiceDiscount));
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SendInvoice()),
      );
    }
  }

  void _add() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState
                  /*You can rename this!*/) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 300,
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: 1,
                                  groupValue: discountTax,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      discountTax = value;
                                    });
                                  }),
                              Text("Discount")
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: 2,
                                  groupValue: discountTax,
                                  onChanged: (value) {
                                    setState(() {
                                      discountTax = value;
                                    });
                                  }),
                              Text("Tax")
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                            controller: _discountDescription,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                            ),
                            controller: _discountAmount,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          PrimaryMiniButton(
                              onPressed: () {
                                Map<String, dynamic> discountDetail = {
                                  "description": _discountDescription.text,
                                  "amount": _discountAmount.text,
                                  "type": discountTax
                                };
                                setState(() {
                                  _children.add(discountDetail);
                                });
                                Navigator.pop(context);
                              },
                              buttonText: Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  int calculateTotal() {
    int total = TotalAndSubTotal().getSubTotal(context,isNewInvoice);

    if(_children.length == 0){

    }else{
      _children.forEach((item){
        if(item["type"] == 2){
              total = total + int.parse(item["amount"]);
        }else{
          total = total - int.parse(item["amount"]);
        }
      });
    }
    return total;
  }
}
