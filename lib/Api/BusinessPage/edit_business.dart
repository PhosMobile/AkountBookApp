import 'package:akount_books/AppState/actions/business_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/business.dart';
import 'package:akount_books/Screens/business_updated.dart';
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

class EditBusiness extends StatefulWidget {
  final Business business;
  EditBusiness({ @required this.business});
  @override
  _EditBusinessState createState() => _EditBusinessState();

}

class _EditBusinessState extends State<EditBusiness> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  String phone;
  String email;
  TextEditingController _businessName = new TextEditingController();
  TextEditingController _businessEmail = new TextEditingController();
  TextEditingController _businessDescription = new TextEditingController();
  TextEditingController _businessAddress = new TextEditingController();
  String currency = "NGN";

  validate(value, errorText) {
    if (value.isEmpty) {
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: HeaderTitle(headerText: "Update Business Info"),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              onInitialBuild: (state){
                Business business = widget.business;
                setState(() {
                  _businessName.text= business.name;
                  _businessEmail.text= business.email;
                  _businessDescription.text= business.description;
                  _businessAddress.text= business.address;
                  currency = business.currency;
                });
              },
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 2, color: Theme.of(context).accentColor))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
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
                                      InkWell(
                                        child: ImageAvatars().attachImage(),
                                      ),
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
                                            attribute: "Business Name",
                                            decoration: inputStyles
                                                .inputMain("Business Name"),
                                            validators: [
                                              FormBuilderValidators.max(70,
                                                  errorText:
                                                  "Business can not be longer than 70 character"),
                                              FormBuilderValidators.required()
                                            ],
                                            controller: _businessName,
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
                                            attribute: "email",
                                            decoration: inputStyles
                                                .inputMain("Email Address"),
                                            validators: [
                                              FormBuilderValidators.minLength(10,
                                                  errorText: "Email too short")
                                            ],
                                            controller: _businessEmail,
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
                                            attribute: "Description",
                                            decoration: inputStyles
                                                .inputMain("Description"),
                                            validators: [
                                              FormBuilderValidators.min(30,
                                                  errorText:
                                                  "Business can not be short than 30 character"),
                                              FormBuilderValidators.required()
                                            ],
                                            controller: _businessDescription,
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
                                            attribute: "office_address",
                                            decoration: inputStyles
                                                .inputMain("Office Address"),
                                            validators: [
                                              FormBuilderValidators.max(70,
                                                  errorText:
                                                  "Address can not be longer than 70 character"),
                                              FormBuilderValidators.required()
                                            ],
                                            controller: _businessAddress,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          decoration: BoxDecoration(boxShadow: [
                                            inputStyles.boxShadowMain(context)
                                          ]),
                                          child: FormBuilderDropdown(
                                            onChanged: (value) {
                                              setState(() {
                                                currency = value;
                                              });
                                            },
                                            attribute: "currency",
                                            decoration: InputDecoration(
                                                labelText: "Currency"),
                                            // initialValue: 'Male',
                                            hint: Text('Select Business Currency'),
                                            validators: [
                                              FormBuilderValidators.required()
                                            ],
                                            items: ['NGN', 'USD', 'EUR']
                                                .map((currency) => DropdownMenuItem(
                                                value: currency,
                                                child: Text("$currency")))
                                                .toList(),
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
                                      : Text("UPDATE BUSINESS",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                  onPressed: () {
                                    if (_fbKey.currentState.saveAndValidate()) {
                                      _updateUserBusiness(widget.business.id);
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
              }),
        ));
  }

  void _updateUserBusiness(businessId) async {
    setState(() {
      _isLoading = true;
    });
    final business = StoreProvider.of<AppState>(context);
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations editBusiness = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
        MutationOptions(
            document: editBusiness.editBusiness(
                businessId,
                _businessName.text,
                _businessEmail.text,
                _businessDescription.text,
                _businessAddress.text,
                currency,
                "null",)));
    if (!result.hasErrors) {
        setState(() {
          _isLoading = false;
          _hasErrors = false;
        });
        dynamic newBusiness = result.data["update_business"];
        Business editedBusiness = Business(
            newBusiness["id"],
            newBusiness["name"],
            newBusiness["email"],
            newBusiness["description"],
            newBusiness["address"],
            newBusiness["currency"],
            newBusiness["image_url"],
            newBusiness["user_id"]);
        business.dispatch(UpdateEditedBusiness(payload: editedBusiness));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BusinessEdited()),
        );
    } else {
      print(result.errors);
      setState(() {
        requestErrors = "Error updating business ...pls try again";
        _isLoading = false;
        _hasErrors = true;
      });
    }
  }
}
