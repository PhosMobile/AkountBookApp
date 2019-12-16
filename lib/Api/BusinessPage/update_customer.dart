import 'package:akount_books/AppState/actions/customer_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Screens/BusinessPage/contact_list.dart';
import 'package:akount_books/Screens/UserPage/dasboard.dart';
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
class UpdateCustomer extends StatefulWidget {
  final Customer customer;
  const UpdateCustomer({@required this.customer});

  @override
  _UpdateCustomerState createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  TextEditingController _customerName = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _address = new TextEditingController();

  validate(value, errorText) {
    if (value.isEmpty) {
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Theme
                .of(context)
                .primaryColor),
            title: HeaderTitle(headerText: "Add New Customer")),
        body: SingleChildScrollView(
            child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              onInitialBuild: (state){
                  setState(() {
                    _customerName.text = widget.customer.name;
                    _email.text =widget.customer.email;
                    _phone.text  = widget.customer.phone;
                    _address.text = widget.customer.address;
                  });

              },
              builder: (context, state) {
                String businessId = state.currentBusiness.id;
                String userId = state.loggedInUser.userId;
                print(state.customerFromContact);
                return Container(
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 0),
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
                                      InkWell(
                                        child: Text(
                                          "IMPORT FROM CONTACT",
                                          style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ContactList(), ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      _hasErrors
                                          ? RequestError(errorText: requestErrors)
                                          : Container(),
                                      InkWell(
                                        child: ImageAvatars().attachImage(),
                                      ),
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
                                            attribute: "Customer Name",
                                            decoration: inputStyles
                                                .inputMain("Customer Name"),
                                            validators: [
                                              FormBuilderValidators.required()
                                            ],
                                            controller: _customerName,
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
                                            keyboardType: TextInputType.number,
                                            attribute: "Phone Number",
                                            decoration:
                                            inputStyles.inputMain("Phone Number"),
                                            validators: [
                                              FormBuilderValidators.required(
                                                  errorText: "Phone field s required")
                                            ],
                                            controller: _phone,
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
                                            attribute: "email",
                                            decoration: inputStyles
                                                .inputMain("Email Address"),
                                            validators: [
                                              FormBuilderValidators.email(
                                                  errorText: "Invalid email")
                                            ],
                                            controller: _email,
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
                                            attribute: "address",
                                            decoration:
                                            inputStyles.inputMain(" Address"),
                                            controller: _address,
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
                                      buttonText: Text("UPDATE CUSTOMER ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 14,
                                              color: Colors.white)),
                                      onPressed: () {
                                        if (_fbKey.currentState.saveAndValidate()) {
                                          _saveCustomerUpdate();
                                        }
                                      },
                                    ),
                                    DeleteMiniButton(
                                      buttonText: _isLoading
                                          ? LoaderLight()
                                          : Text("DELETE CUSTOMER",
                                          style: TextStyle(
                                              fontSize: 16, color: Color.fromRGBO(133, 2, 2, 1))),
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        final store = StoreProvider.of<AppState>(context);
                                        GqlConfig graphQLConfiguration = GqlConfig();
                                        Mutations deleteCustomer = new Mutations();
                                        QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
                                            MutationOptions(
                                                document: deleteCustomer.deleteCustomer(
                                                    widget.customer.id
                                                )));
                                        if(result.hasErrors){
                                        }else{
                                          dynamic customer = result.data["delete_customer"];
                                          Customer _customer = Customer(
                                              customer["id"],
                                              customer["name"],
                                              customer["email"],
                                              customer["phone"],
                                              customer["address"],
                                              customer["currency"],
                                              customer["image_url"],
                                              customer["business_id"],
                                              customer["user_id"]);
                                          store.dispatch(DeleteCustomer(payload: _customer));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Dashboard(currentTab: 1)),
                                          );
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
              },
            )));
  }
  void _saveCustomerUpdate() async {
    setState(() {
      _isLoading = true;
    });
    final store = StoreProvider.of<AppState>(context);

    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations updateCustomer = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
        MutationOptions(
            document: updateCustomer.updateCustomer(
                widget.customer.id,
                _customerName.text,
                _email.text,
                _phone.text,
                _address.text,
                null)));
    if (!result.hasErrors) {
      var resultData = result.data["update_customer"];
      Customer _customer = Customer(
          resultData["id"],
          resultData["name"],
          resultData["email"],
          resultData["phone"],
          resultData["address"],
          resultData["currency"],
          resultData["image_url"],
          resultData["business_id"],
          resultData["user_id"]);
      store.dispatch(UpdateEditedCustomer(payload: _customer));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(currentTab: 1)),
      );

    } else {
      print(result.errors);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
