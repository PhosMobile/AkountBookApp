import 'package:flutter/material.dart';

class LoadingSnackBar{
  SnackBar loader(text, context){
    return SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      duration: new Duration(hours: 1),
      content: Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              strokeWidth: 3,
            ),
            SizedBox(width: 30,),
            new Text(text, style: TextStyle(color: Theme.of(context).primaryColor),)
          ],
        )
      ),
      elevation: 0,
    );
  }

  SnackBar loaderHigh(text, context){
    return SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      duration: new Duration(hours: 1),
      content: Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              strokeWidth: 3,
            ),
            SizedBox(width: 30,),
            new Text(text, style: TextStyle(color: Theme.of(context).primaryColor),)
          ],
        ),
      ),
      elevation: 0,
    );
  }

}