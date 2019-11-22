import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/Models/invoice_name.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState/app_state.dart';

class AddInvoiceName extends StatefulWidget {
  @override
  _AddInvoiceNameState createState() => _AddInvoiceNameState();
}
class _AddInvoiceNameState extends State<AddInvoiceName> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;

  TextEditingController _invoiceTitle = new TextEditingController();
  TextEditingController _invoiceNumber = new TextEditingController();
  TextEditingController _poSoNumber = new TextEditingController();
  TextEditingController _summary = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: HeaderTitle(headerText: "Invoice Name")),
        body: SingleChildScrollView(
          child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state){
              InvoiceName invoiceNameFromState = state.invoiceName;
              if(invoiceNameFromState != null){
                _invoiceTitle.text = invoiceNameFromState.title;
                _invoiceNumber.text = invoiceNameFromState.invoice_number;
                _poSoNumber.text = invoiceNameFromState.po_so_number;
                _summary.text = invoiceNameFromState.summary;
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
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        inputStyles.boxShadowMain(context)
                                      ]),
                                      child: FormBuilderTextField(
                                        attribute: "Invoice Title",
                                        decoration:
                                        inputStyles.inputMain("Invoice Title"),
                                        validators: [FormBuilderValidators.required()],
                                        controller: _invoiceTitle,
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
                                        keyboardType: TextInputType.number,
                                        attribute: "Invoice Number",
                                        decoration:
                                        inputStyles.inputMain("Invoice Number"),
                                        validators: [
                                          FormBuilderValidators.minLength(7,
                                              errorText: "Email too short"),
                                          FormBuilderValidators.required()
                                        ],
                                        controller: _invoiceNumber,
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
                                        attribute: "P.O / S.O Number",
                                        decoration:
                                        inputStyles.inputMain("P.O / S.O Number"),
                                        validators: [FormBuilderValidators.required()],
                                        controller: _poSoNumber,
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
                                        attribute: "Summary",
                                        decoration: inputStyles.inputMain("Summary"),
                                        validators: [
                                          FormBuilderValidators.max(70,
                                              errorText: "Summary"),
                                          FormBuilderValidators.required()
                                        ],
                                        controller: _summary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            PrimaryButton(
                              buttonText: _isLoading
                                  ? LoaderLight()
                                  : Text("PROCEED",
                                  style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                              onPressed: () {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  _saveInvoiceName(context);
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
              );
            },
          ),
        ));
  }
  void _saveInvoiceName(context){
    final invoiceNameProvider = StoreProvider.of<AppState>(context);
    InvoiceName _invoiceName = new InvoiceName(_invoiceTitle.text, _invoiceNumber.text, _poSoNumber.text, _summary.text);
    invoiceNameProvider.dispatch(AddInvoice(payload: _invoiceName));

    Navigator.pop(context);
  }
}
