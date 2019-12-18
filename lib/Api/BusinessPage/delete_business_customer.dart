import 'package:akaunt/AppState/actions/customer_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Screens/UserPage/dasboard.dart';
import 'package:akaunt/Widgets/buttons.dart';
import 'package:akaunt/Widgets/delete_success.dart';
import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:localstorage/localstorage.dart';

final Widget svg = new SvgPicture.asset(
  SVGFiles.delete,
  semanticsLabel: 'Akaunt-book',
  allowDrawingOutsideViewBox: true,
);
class DeleteBusinessCustomer extends StatefulWidget {
  final Customer customer;
  DeleteBusinessCustomer({ @required this.customer});
  @override
  _DeleteBusinessCustomerState createState() => _DeleteBusinessCustomerState();
}

class _DeleteBusinessCustomerState extends State<DeleteBusinessCustomer> {
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = new LocalStorage('some_key');
    return Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: StoreConnector<AppState, AppState>(
            converter: (store)=>store.state,
            builder: (context, state){
              return Container(
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
                ),
                child: new Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            svg,
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                "Are you sure you want to delete  \n ${widget.customer.name} from  ${state.currentBusiness.name}, Customers records will be lost",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        DeleteButton(
                            buttonText: Text("DELETE",
                                style: TextStyle(fontSize: 16, color: Colors.white)),
                            onPressed: () async{
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

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DeleteSuccess(message: "You have successfully deleted ${widget.customer.name}  \n from  ${state.currentBusiness.name}",nextScreen: Dashboard(currentTab: 1,),nextScreenText: "Customer",)),
                                );


                              }


                            }),
                        SizedBox(
                          height: 10,
                        ),
                        CancelButton(
                            buttonText: Text("CANCEL",
                                style: TextStyle(fontSize: 16, color:Theme.of(context).primaryColor )),
                            onPressed: () {
                              storage.deleteItem("fromRegistration");
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ),
                ),
              );
            }
        ));
  }
}
