import 'package:akount_books/AppState/actions/item_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/error.dart';
import 'package:akount_books/Widgets/loader_widget.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akount_books/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  TextEditingController _itemName = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _quantity = new TextEditingController();
  TextEditingController _price = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme
                .of(context)
                .primaryColor),
            title: HeaderTitle(headerText: "Add New Item")),
        body: SingleChildScrollView(
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) {
                  String businessId = state.currentBusiness.id;
                  String userId = state.loggedInUser.user_id;
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
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
                                            ? RequestError(
                                            errorText: requestErrors)
                                            : Container(),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10),
                                          child: Container(
                                            decoration: BoxDecoration(boxShadow: [
                                              inputStyles.boxShadowMain(context)
                                            ]),
                                            child: FormBuilderTextField(
                                              attribute: "Item Name",
                                              decoration:
                                              inputStyles.inputMain("Item Name"),
                                              validators: [
                                                FormBuilderValidators.required()
                                              ],
                                              controller: _itemName,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10),
                                          child: Container(
                                            decoration: BoxDecoration(boxShadow: [
                                              inputStyles.boxShadowMain(context)
                                            ]),
                                            child: FormBuilderTextField(
                                              attribute: "description",
                                              decoration: inputStyles
                                                  .inputMain("Description"),
                                              controller: _description,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width:
                                              MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width /
                                                  2 -
                                                  50,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    inputStyles.boxShadowMain(
                                                        context)
                                                  ]),
                                              child: FormBuilderTextField(
                                                keyboardType: TextInputType
                                                    .number,
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
                                              width:
                                              MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width /
                                                  2 -
                                                  50,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    inputStyles.boxShadowMain(
                                                        context)
                                                  ]),
                                              child: FormBuilderTextField(
                                                keyboardType: TextInputType
                                                    .number,
                                                attribute: "price",
                                                decoration:
                                                inputStyles.inputMain("Price"),
                                                validators: [
                                                  FormBuilderValidators.required()
                                                ],
                                                controller: _price,
                                              ),
                                            ),
                                          ],
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
                                        : Text("ADD ITEM",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                    onPressed: () {
                                      if (_fbKey.currentState.saveAndValidate()) {
                                        _addItem(businessId, userId);
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
                })));
  }

  void _addItem(businessId, userId) async {
    setState(() {
      _isLoading = true;
    });
    final addItem = StoreProvider.of<AppState>(context);

    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createItem = new Mutations();
    QueryResult result =
    await graphQLConfiguration.getGraphql(context).mutate(MutationOptions(
        document: createItem.createItem(
          _itemName.text,
          _description.text,
          int.parse(_quantity.text),
          int.parse(_price.text),
          businessId,
          userId,
        )));
    if (!result.hasErrors) {
      var result_data = result.data["create_item"];
      Item _item = new Item(
          result_data["id"],
          result_data["name"],
          result_data["description"],
          result_data["quantity"],
          result_data["price"],
          result_data["business_id"],
          result_data["user_id"]);
      addItem.dispatch(UpdateBusinessItems(payload: _item));
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    } else {
      print(result.errors);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
