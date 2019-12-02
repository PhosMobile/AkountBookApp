import 'package:akount_books/Api/BusinessPage/InvoiceItems.dart';
import 'package:akount_books/Api/BusinessPage/edit_invoice_name.dart';
import 'package:akount_books/Api/BusinessPage/send_invoice.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/edit_invoice.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/invoice_name.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Screens/BusinessPage/edit_customer_list.dart';
import 'package:akount_books/Screens/BusinessPage/edit_item_list.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/invoice_item_card.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/loading_snack_bar.dart';
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

class UpdateInvoiceData extends StatefulWidget {
  @override
  _UpdateInvoiceDataState createState() => _UpdateInvoiceDataState();
}
class _UpdateInvoiceDataState extends State<UpdateInvoiceData> {
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
  String _invoiceName = "INVOICE NAME";
  String invoiceDate = "";
  String dueDate = "";
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
            title: HeaderTitle(headerText: "Update Invoice")),
        body: SingleChildScrollView(
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                EditInvoice invoiceData = state.editInvoice;
                InvoiceName invoiceNameData = InvoiceName(
                    invoiceData.title,
                    invoiceData.number,
                    invoiceData.po_so_number,
                    invoiceData.summary);
                String businessId = state.currentBusiness.id;
                String userId = state.loggedInUser.user_id;

                _subTotal.text  = invoiceData.sub_total_amount.toString();
                _total.text = invoiceData.total_amount.toString();
                _notes.text = invoiceData.notes;
                _footer.text = invoiceData.footer;

                if (state.editInvoice != null) {
                  _invoiceName = invoiceNameData.title;
                  _invoiceDescription = invoiceNameData.summary;
                  _invoiceNumber = invoiceNameData.po_so_number;
                }
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
                                                EditInvoiceName()),
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
                                                  ? invoiceData.issue_date
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
                                                  ? invoiceData.due_date
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
                                            invoiceData.invoiceCustomer == null
                                                ? "Edit Customer"
                                                : invoiceData.invoiceCustomer.name,
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
                                                      EditCustomerList()),
                                            );
                                          },
                                        )),
                                  ),
                                  invoiceData.invoiceItem.length != 0
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
                                                      invoiceData.invoiceItem.length
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
                                            // ignore: sdk_version_ui_as_code
                                            for (var item in invoiceData.invoiceItem)
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
                                          "Edit Items",
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
                                                    EditItemList()),
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                50,
                                        decoration: BoxDecoration(boxShadow: [
                                          inputStyles.boxShadowMain(context)
                                        ]),
                                        child: FormBuilderTextField(

                                          keyboardType: TextInputType.number,
                                          attribute: "sub_total",
                                          decoration: inputStyles
                                              .inputMain("Sub Total"),
                                          validators: [
                                            FormBuilderValidators.required(),
                                            FormBuilderValidators.numeric()
                                          ],
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
                                      : Text("UPDATE INFO",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 14,
                                              color: Colors.white)),
                                  onPressed: () {
                                    if (_fbKey.currentState.saveAndValidate()) {
                                      _updateInvoice(
                                          state.editInvoice,
                                        state.currentBusiness.id,
                                        state.loggedInUser.user_id
                                      );
                                    }
                                  },
                                ),
                                DeleteMiniButton(
                                  buttonText: _isDraftLoading
                                      ? LoaderLight()
                                      : Text("DELETE INVOICE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 14,
                                              color: Colors.redAccent)),
                                  onPressed: () {

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

  void _updateInvoice(EditInvoice invoiceData, businessId, userId) async {
    final addInvoice = StoreProvider.of<AppState>(context);
    scaffoldState.currentState.showSnackBar(
        LoadingSnackBar().loader("  Updating Invoice...", context));

    List<Item> invoiceItems = invoiceData.invoiceItem;
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations _updateInvoice = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql().mutate(
        MutationOptions(
            document: _updateInvoice.updateInvoice(
                invoiceData.id,
                invoiceData.title,
                invoiceData.number,
                invoiceData.po_so_number,
                invoiceData.summary,
                invoiceData.issue_date,
                invoiceData.due_date,
                invoiceData.sub_total_amount,
                invoiceData.total_amount,
                invoiceData.notes,
                invoiceData.status,
                invoiceData.footer,
                invoiceData.invoiceCustomer.id)));

    if (!result.hasErrors) {
      String  itemUpdated = await InvoiceItems().updateInvoiceItems(
          invoiceItems, invoiceData.id);
      if(itemUpdated == "Done"){
        Invoice _invoice = new Invoice(
            invoiceData.id,
            invoiceData.title,
            invoiceData.number,
            invoiceData.po_so_number,
            invoiceData.summary,
            invoiceData.issue_date,
            invoiceData.due_date,
            invoiceData.sub_total_amount,
            invoiceData.total_amount,
            invoiceData.notes,
            invoiceData.status,
            invoiceData.footer,
            invoiceData.invoiceCustomer.id,
            businessId,
            userId);
        addInvoice.dispatch(UpdateBusinessInvoice(payload: _invoice));
        Navigator.pushNamed(context, "/user_dashboard");
      }
    }else{
      print(result.errors);
    }

    }
  }

