import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget buttonText;

  PrimaryButton({@required this.onPressed, @required this.buttonText});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).accentColor,
        child: Padding(padding: EdgeInsets.all(20.0), child: buttonText),
        onPressed: onPressed,
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final Widget buttonText;

  SecondaryButton({@required this.onPressed, @required this.buttonText});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: RaisedButton(
        color: Theme.of(context).accentColor,
        splashColor: Theme.of(context).accentColor,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: buttonText,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class PrimaryMiniButton extends StatelessWidget {
  final Widget buttonText;

  PrimaryMiniButton({@required this.onPressed, @required this.buttonText});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 2 - 30,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).accentColor,
        child: Padding(padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: buttonText),
        onPressed: onPressed,
      ),
    );
  }
}

class SecondaryMiniButton extends StatelessWidget {
  final Widget buttonText;

  SecondaryMiniButton({@required this.onPressed, @required this.buttonText});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 2 - 30,
      child: RaisedButton(
        color: Theme.of(context).accentColor,
        splashColor: Theme.of(context).primaryColor,
        child: Padding(padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: buttonText),
        onPressed: onPressed,
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final Widget buttonText;

  DeleteButton({@required this.onPressed, @required this.buttonText});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: RaisedButton(
        color: Color.fromRGBO(183, 4, 4, 1),
        splashColor: Color.fromRGBO(183, 4, 4, 1),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: buttonText,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final Widget buttonText;

  CancelButton({@required this.onPressed, @required this.buttonText});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: InkWell(
        splashColor: Color.fromRGBO(183, 4, 4, 1),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: buttonText,
          ),
        ),
        onTap: onPressed,
      ),
    );
  }
}



class DeleteMiniButton extends StatelessWidget {
  final Widget buttonText;

  DeleteMiniButton({@required this.onPressed, @required this.buttonText});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2-40,
      child: RaisedButton(
        color: Color.fromRGBO(255, 219, 219, 1),
        splashColor: Color.fromRGBO(183, 4, 4, .5),
        child: Padding(padding: EdgeInsets.only(top:20.0,bottom: 20.0), child: buttonText),
        onPressed: onPressed,
      ),
    );
  }
}

class DatePickerButton extends StatelessWidget {
  final Widget buttonText;
  final dynamic icon;

  DatePickerButton(
      {@required this.onPressed,
      @required this.buttonText,
      @required this.icon});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 2 - 30,
      child: RaisedButton(
        color: Colors.white,
        splashColor: Theme.of(context).accentColor,
        child: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[buttonText, icon],
            )),
        onPressed: onPressed,
      ),
    );
  }
}

class DatePickerButtonFull extends StatelessWidget {
  final Widget buttonText;
  final Icon icon;

  DatePickerButtonFull(
      {@required this.onPressed,
      @required this.buttonText,
      @required this.icon});

  final GestureTapCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 30,
      child: RaisedButton(
        color: Theme.of(context).accentColor,
        splashColor: Theme.of(context).accentColor,
        child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[buttonText, icon],
            )),
        onPressed: onPressed,
      ),
    );
  }
}

class ChooseButton extends StatelessWidget {
  final Widget buttonText;
  final dynamic icon;

  ChooseButton(
      {@required this.onPressed,
      @required this.buttonText,
      @required this.icon});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 30,
      child: RaisedButton(
        color: Colors.white,
        splashColor: Theme.of(context).accentColor,
        child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                icon,
                SizedBox(
                  width: 10,
                ),
                buttonText,
              ],
            )),
        onPressed: onPressed,
      ),
    );
  }
}
