import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Widgets/logo_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
class InvoiceHeader extends StatelessWidget {
  final String status;

  const InvoiceHeader({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImageAvatars logo = new ImageAvatars();
    return StoreConnector<AppState, AppState>(
      converter: (store)=>store.state,
      builder: (context, state){
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    logo.miniLogoAvatar(),
                    SizedBox(height: 15,),
                    Text("${state.currentBusiness.name.toUpperCase()}", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text("${state.currentBusiness.address}", style: TextStyle(fontSize: 12),)

                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(255, 227, 209, 1), width: 3),
                  color: Color.fromRGBO(255, 249, 245, 1)
                ),
                padding: EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                child: Text("$status"),
              )
            ],
          ),
        );
      },
    );
  }
}
