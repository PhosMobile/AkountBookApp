
import 'package:akount_books/Api/BusinessPage/current_business_data.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Screens/UserPage/dasboard.dart';
import 'package:akount_books/Widgets/buttons.dart';
import 'package:akount_books/Widgets/delete_success.dart';
import 'package:akount_books/Widgets/loading_snack_bar.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:localstorage/localstorage.dart';

final Widget svg = new SvgPicture.asset(
  SVGFiles.delete,
  semanticsLabel: 'Akount-book',
  allowDrawingOutsideViewBox: true,
);
class DeleteAnInvoice extends StatefulWidget {
  final String invoiceId;
  DeleteAnInvoice({ @required this.invoiceId});
  @override
  _DeleteAnInvoiceState createState() => _DeleteAnInvoiceState();
}

class _DeleteAnInvoiceState extends State<DeleteAnInvoice> {
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
                              "Are you sure you want to delete  \n this invoice",
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
                            _scaffoldState.currentState
                                .removeCurrentSnackBar();
                            _scaffoldState.currentState
                                .showSnackBar(LoadingSnackBar()
                                .loader(
                                "  Deleting Invoice...",
                                context));
                            GqlConfig graphQLConfiguration =
                            GqlConfig();
                            Mutations deleteInvoice =
                            new Mutations();
                            QueryResult result =
                            await graphQLConfiguration
                                .getGraphql(context)
                                .mutate(MutationOptions(
                                document: deleteInvoice
                                    .deleteInvoice(widget.invoiceId)));
                            if (result.hasErrors) {
                              print(result.errors);
                            } else {
                              await CurrentBusinessData().getBusinessData(context, state.currentBusiness.id);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeleteSuccess(message: "You have successfully deleted invoice",nextScreen: Dashboard(currentTab: 0,),)),
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
