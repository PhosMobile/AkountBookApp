import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Akount Books"),
        // backgroundColor: Colors.orange[800],
      ),
      body: new Container(
        padding: EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("Welcome"),
              new Center(
                  child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                      child: new Text("Register"),
                      color: Colors.orange[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                          side: BorderSide(color: Colors.red)),
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      }),
                  new RaisedButton(
                    child: new Text("Login"),
                    color: Colors.orange[40],
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30),
                        side: BorderSide(color: Colors.red)),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
