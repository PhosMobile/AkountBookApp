import 'package:akaunt/Api/BusinessPage/upload_file.dart';
import 'package:akaunt/AppState/actions/customer_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/user_phone_contact.dart';
import 'package:akaunt/Screens/BusinessPage/contact_list.dart';
import 'package:akaunt/Screens/customer_created.dart';
import 'package:akaunt/Widgets/DisplayAttachedImage.dart';
import 'package:akaunt/Widgets/HeaderTitle.dart';
import 'package:akaunt/Widgets/error.dart';
import 'package:akaunt/Widgets/loader_widget.dart';
import 'package:akaunt/Widgets/logo_avatar.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/utilities/attach_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akaunt/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
class AddCustomer extends StatefulWidget {
  final bool direct;
  const AddCustomer({@required this.direct});

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  InputStyles inputStyles = new InputStyles();
  ImageAvatars logo = new ImageAvatars();
  String requestErrors;
  bool _isLoading = false;
  bool _hasErrors = false;
  TextEditingController _customerName = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  var  image;
  AttachImage attachImage = AttachImage();

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
            iconTheme: IconThemeData(color: Theme
                .of(context)
                .primaryColor),
            title: HeaderTitle(headerText: "Add New Customer")),
        body: SingleChildScrollView(
            child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              onInitialBuild: (state){

                if(state.customerFromContact != null){
                  UserPhoneContact contact = state.customerFromContact;
                  setState(() {
                    _customerName.text = contact.displayName;
                    _email.text =contact.email;
                    _phone.text  = contact.phone;
                    _address.text = contact.address;
                  });
                }
              },
              builder: (context, state) {
                String businessId = state.currentBusiness.id;
                String userId = state.loggedInUser.userId;
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
                                        child: image == null ? ImageAvatars().attachImage(): DisplayImage().displayAttachedProfileImage(image),
                                        onTap: ()async{
                                          var profileImage = await attachImage.getProfileImage();
                                          setState(() {
                                            image = profileImage;
                                          });
                                        },
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
                                PrimaryButton(
                                  buttonText: _isLoading
                                      ? LoaderLight()
                                      : Text("ADD CUSTOMER",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                  onPressed: () {
                                    if (_fbKey.currentState.saveAndValidate()) {
                                      _addCustomer(businessId, userId);
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
            )));
  }
  void _addCustomer(businessId, userId) async {
    setState(() {
      _isLoading = true;
    });

    var firebaseRef = await UploadFile().uploadProfileImage(_scaffoldKey, context, image);

    if(firebaseRef == null){
      _registerCustomer("null",businessId, userId);
    }else{
      firebaseRef.getDownloadURL().then((fileURL) async{
        _registerCustomer(fileURL,businessId, userId);
      });
    }
  }
  void _registerCustomer(imageUrl, businessId, userId) async {
    setState(() {
      _isLoading = true;
    });
    final addCustomer = StoreProvider.of<AppState>(context);
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createCustomer = new Mutations();
    QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
        MutationOptions(
            document: createCustomer.createCustomer(
                _customerName.text,
                _email.text,
                _phone.text,
                _address.text,
                businessId,
                userId,
                imageUrl)));
    if (!result.hasErrors) {
      var resultData = result.data["create_customer"];
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
      addCustomer.dispatch(UpdateBusinessCustomers(payload: _customer));
      setState(() {
        _isLoading = false;
      });
      if(widget.direct){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerCreated(customer:_customer)),
        );
      }else{
        Navigator.pop(context);
      }
    } else {
      print(result.errors);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
