import 'dart:io';
import 'package:akaunt/Api/BusinessPage/current_business_data.dart';
import 'package:akaunt/Api/BusinessPage/upload_file.dart';
import 'package:akaunt/Api/UserAcount/logged_in_user.dart';
import 'package:akaunt/AppState/actions/business_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Models/business.dart';
import 'package:akaunt/Service/localstorage_service.dart';
import 'package:akaunt/Widgets/HeaderTitle.dart';
import 'package:akaunt/Widgets/error.dart';
import 'package:akaunt/Widgets/loader_widget.dart';
import 'package:akaunt/Widgets/loading_snack_bar.dart';
import 'package:akaunt/Widgets/logo_avatar.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/service_locator.dart';
import 'package:akaunt/utilities/attach_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:akaunt/Widgets/Input_styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:akaunt/Widgets/DisplayAttachedImage.dart';

class AddBusiness extends StatefulWidget {
  @override
  _AddBusinessState createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//  final key = GlobalKey<ImageCropState>();
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
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: HeaderTitle(headerText: "Set Up a Business Page"),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
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
                                    child: image == null ? ImageAvatars().attachImage(): DisplayImage().displayAttachedProfileImage(image),
                                    onTap: () async {
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
                                    padding: const EdgeInsets.only(bottom: 50),
                                    child: Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        inputStyles.dropDownMenu(context)
                                      ],
                                      border: Border.all(color: Theme.of(context).accentColor, width: 3) ),

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
                                  : Text("REGISTER BUSINESS",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                              onPressed: () {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  _addUserBusiness();
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


  void _addUserBusiness() async {
    setState(() {
      _isLoading = true;
    });


    var firebaseRef = await UploadFile().uploadProfileImage(_scaffoldKey, context, image);

    if(firebaseRef == null){
      _registerBusiness("null");
    }else{
      firebaseRef.getDownloadURL().then((fileURL) async{
        _registerBusiness(fileURL);
      });
    }
  }

  void _registerBusiness(imageUrl) async {
    setState(() {
      _isLoading = true;
    });
    String userId;
    String userEmail;
    String userPassword;

    final loggedInUser = StoreProvider.of<AppState>(context);
    final LocalStorage storage = new LocalStorage('some_key');
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getStringList('user_credentials') ?? [];
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createBusiness = new Mutations();

      if (user.length == 0) {
        userId = loggedInUser.state.loggedInUser.userId;
      } else {
        userEmail = user[0];
        userPassword = user[1];
        userId = user[2];
      }
      QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
          MutationOptions(
              document: createBusiness.createBusiness(
                  _businessName.text,
                  _businessEmail.text,
                  _businessDescription.text,
                  _businessAddress.text,
                  currency,
                  imageUrl,
                  userId)));
      if (!result.hasErrors) {
        if (user.length == 0) {
          setState(() {
            _isLoading = false;
            _hasErrors = false;
          });
          dynamic newBusiness = result.data["create_business"];
          Business currentBusiness = Business(
              newBusiness["id"],
              newBusiness["name"],
              newBusiness["email"],
              newBusiness["description"],
              newBusiness["address"],
              newBusiness["currency"],
              newBusiness["image_url"],
              newBusiness["user_id"]);
          final business = StoreProvider.of<AppState>(context);
          business.dispatch(UserCurrentBusiness(payload: currentBusiness));
          business.dispatch(UpdateUserBusiness(payload: currentBusiness));
          _scaffoldKey.currentState.showSnackBar(
              LoadingSnackBar().loader("  Getting Business Data...", context));
          CurrentBusinessData().getBusinessData(context, currentBusiness.id);
        } else {
          GqlConfig graphQLConfiguration = GqlConfig();
          Mutations login = new Mutations();
          QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
            MutationOptions(document: login.login(userEmail, userPassword)),
          );
          if (!result.hasErrors) {
            setState(() {
              _isLoading = false;
              _hasErrors = false;
            });
            var accessToken = result.data["login"];
            prefs.setString('access_token', accessToken["access_token"]);
            storage.setItem("access_token", accessToken["access_token"]);
            locator<LocalStorageService>().hasLoggedIn = true;
            await LoggedInUser().fetchLoggedInUser(context, "registeration");

          } else {
            setState(() {
              requestErrors = result.errors.toString().substring(10, 36);
              _isLoading = false;
              _hasErrors = true;
            });
          }
        }
      } else {
        print(result.errors);
        setState(() {
          requestErrors = "Error ...pls try again";
          _isLoading = false;
          _hasErrors = true;
        });
      }

  }
}
