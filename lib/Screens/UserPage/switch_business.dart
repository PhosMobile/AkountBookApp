import 'package:akaunt/Api/BusinessPage/create_business.dart';
import 'package:akaunt/Api/BusinessPage/current_business_data.dart';
import 'package:akaunt/Api/BusinessPage/edit_business.dart';
import 'package:akaunt/AppState/actions/business_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Models/business.dart';
import 'package:akaunt/Widgets/HeaderTitle.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/loading_snack_bar.dart';
import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SwitchBusiness extends StatefulWidget {

  @override
  _SwitchBusinessState createState() => _SwitchBusinessState();
}

class _SwitchBusinessState extends State<SwitchBusiness> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Business currentBusiness;
  final Widget switchBusiness = new SvgPicture.asset(
    SVGFiles.switch_business,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );
  bool snackActive = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: HeaderTitle(headerText: "Switch Accounts")),
      body: Container(
        color: Colors.white,
        child: StoreConnector<AppState, AppState>(
            onInitialBuild: (store) {
              setState(() {
                currentBusiness = store.currentBusiness;
              });
            },
            converter: (store) => store.state,
            builder: (context, state) {
              List<Business> accountBusinesses = state.userBusinesses;
              return Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: accountBusinesses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                child: Container(
                                  decoration: currentBusiness ==
                                          accountBusinesses[index]
                                      ? BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          border: Border(
                                              left: BorderSide(
                                                  width: 10,
                                                  color: Theme.of(context)
                                                      .primaryColor)))
                                      : BoxDecoration(
                                          color:
                                              Color.fromRGBO(248, 248, 248, 1),
                                        ),
                                  padding: EdgeInsets.only(left: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0),
                                            child: Container(
                                                width: 35,
                                                child: switchBusiness)),
                                        Expanded(
                                          child: Text(
                                            accountBusinesses[index].name,
                                            style: TextStyle(
                                                color: Colors.blueGrey[20]),
                                          ),
                                        ),
                                        Radio(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.padded,
                                          groupValue: currentBusiness,
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          value: accountBusinesses[index],
                                          onChanged: (Business value) {
                                            setState(() {
                                              currentBusiness = value;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onLongPressEnd: (dragDetail) {
                                  setState(() {
                                    currentBusiness = accountBusinesses[index];
                                    snackActive = true;
                                  });
                                  _scaffoldKey.currentState
                                      .removeCurrentSnackBar();
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor:
                                        Color.fromRGBO(4, 100, 183, 1),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        InkWell(
                                          child: Icon(MdiIcons.fileEdit),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditBusiness(business: accountBusinesses[index])),
                                            );
                                          },
                                        ),
                                        InkWell(
                                          child: Icon(MdiIcons.delete),
                                          onTap: () async {
                                            _scaffoldKey.currentState
                                                .removeCurrentSnackBar();
                                            _scaffoldKey.currentState
                                                .showSnackBar(LoadingSnackBar()
                                                    .loader(
                                                        "  Deleting Business...",
                                                        context));
                                            GqlConfig graphQLConfiguration =
                                                GqlConfig();
                                            Mutations deleteBusiness =
                                                new Mutations();
                                            QueryResult result =
                                                await graphQLConfiguration
                                                    .getGraphql(context)
                                                    .mutate(MutationOptions(
                                                        document: deleteBusiness
                                                            .deleteBusiness(
                                                                accountBusinesses[
                                                                        index]
                                                                    .id)));
                                            if (result.hasErrors) {
                                            } else {
                                              final editInvoice =
                                                  StoreProvider.of<AppState>(
                                                      context);
                                              editInvoice.dispatch(
                                                  RemoveDeletedBusiness(
                                                      payload:
                                                          accountBusinesses[
                                                              index]));
                                              if (accountBusinesses.length >
                                                  0) {
                                                setState(() {
                                                  currentBusiness =
                                                      accountBusinesses[0];
                                                });
                                                CurrentBusinessData()
                                                    .getBusinessData(context,
                                                        currentBusiness.id);
                                              } else {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddBusiness()),
                                                );
                                              }
                                              _scaffoldKey.currentState
                                                  .removeCurrentSnackBar();
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                    duration: Duration(hours: 1),
                                  ));
                                },
                                onTap: () {
                                  _scaffoldKey.currentState
                                      .removeCurrentSnackBar(
                                          reason: SnackBarClosedReason.timeout);
                                  setState(() {
                                    currentBusiness = accountBusinesses[index];
                                  });
                                },
                              );
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red,
                      child: PrimaryButton(
                          onPressed: () async {
                            final business =
                                StoreProvider.of<AppState>(context);
                            business.dispatch(
                                UserCurrentBusiness(payload: currentBusiness));
                            _scaffoldKey.currentState.showSnackBar(
                                LoadingSnackBar().loader(
                                    "  Getting Business Data...", context));
                            CurrentBusinessData()
                                .getBusinessData(context, currentBusiness.id);
                          },
                          buttonText: Text(
                            "SWITCH",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
