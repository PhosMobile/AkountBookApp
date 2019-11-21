import 'package:akount_books/Api/BusinessPage/current_business_data.dart';
import 'package:akount_books/AppState/actions/business_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/business.dart';
import 'package:akount_books/Widgets/HeaderTitle.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SwitchBusiness extends StatefulWidget {
  @override
  _SwitchBusinessState createState() => _SwitchBusinessState();
}

class _SwitchBusinessState extends State<SwitchBusiness> {
  Business currentBusiness;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: HeaderTitle(headerText: "Switch Accounts")),
      body: Container(
        child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              List<Business> accountBusinesses = state.userBusinesses;
              return Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: ListView.builder(
                            itemCount: accountBusinesses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: CircleAvatar(
                                            backgroundColor: Color.fromRGBO(
                                                200, 228, 253, 0.4),
                                            child: Icon(
                                              Icons.business,
                                              color: Colors.blueGrey,
                                              size: 25,
                                            ))),
                                    Expanded(
                                        child: Text(
                                      accountBusinesses[index].name,
                                      style:
                                          TextStyle(color: Colors.blueGrey[20]),
                                    )),
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
                                        })
                                  ],
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
                            CurrentBusinessData()
                                .getBusinessData(context, currentBusiness.id);
//                              Navigator.pushNamed(context, "/user_dashboard");
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
