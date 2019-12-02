import 'package:akount_books/Api/BusinessPage/current_business_data.dart';
import 'package:akount_books/AppState/actions/business_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/business.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/loading_snack_bar.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SwitchBusiness extends StatefulWidget {
  @override
  _SwitchBusinessState createState() => _SwitchBusinessState();
}
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
class _SwitchBusinessState extends State<SwitchBusiness> {
  Business currentBusiness;
  final Widget switchBusiness = new SvgPicture.asset(
    SVGFiles.switch_business,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );

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
                              return Container(
                                color: Color.fromRGBO(248, 248, 248, 1),
                                padding: EdgeInsets.only(left: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: Container(width:35,child: switchBusiness)),
                                      Expanded(
                                          child: InkWell(
                                              child: Text(
                                                accountBusinesses[index].name,
                                                style: TextStyle(
                                                    color: Colors.blueGrey[20]),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  currentBusiness =
                                                      accountBusinesses[index];
                                                });
                                              })),
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
                          onPressed: () {
                            final business =
                                StoreProvider.of<AppState>(context);
                            business.dispatch(
                                UserCurrentBusiness(payload: currentBusiness));
                            _scaffoldKey.currentState.showSnackBar(
                                LoadingSnackBar().loader("  Getting Business Data...", context));
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
