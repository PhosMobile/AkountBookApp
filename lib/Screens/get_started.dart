//import 'package:flutter/material.dart';
//
//class GetStarted extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("akaunt Books"),
//        // backgroundColor: Colors.orange[800],
//      ),
//      body: new Container(
//        padding: EdgeInsets.all(32.0),
//        child: new Center(
//          child: new Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              new Text("Welcome"),
//              new Center(
//                  child: new Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  new RaisedButton(
//                      child: new Text("Register"),
//                      color: Colors.orange[900],
//                      shape: RoundedRectangleBorder(
//                          borderRadius: new BorderRadius.circular(30),
//                          side: BorderSide(color: Colors.red)),
//                      textColor: Colors.white,
//                      onPressed: () {
//                        Navigator.pushNamed(context, "/register");
//                      }),
//                  new RaisedButton(
//                    child: new Text("Login"),
//                    color: Colors.orange[40],
//                    onPressed: () {
//                      Navigator.pushNamed(context, "/login");
//                    },
//                    shape: RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(30),
//                        side: BorderSide(color: Colors.red)),
//                  )
//                ],
//              ))
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
import 'dart:async';
import 'package:akaunt/Widgets/logo_avatar.dart';
import 'package:akaunt/Widgets/slide_dots.dart';
import 'package:akaunt/Widgets/slide_item.dart';
import 'package:flutter/material.dart';
import 'package:akaunt/Models/slide.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  ImageAvatars logo = new ImageAvatars();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              logo.miniLogoAvatar(),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: slideList.length,
                        itemBuilder: (ctx, i) => SlideItem(i),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 35),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for(int i = 0; i < slideList.length; i++)
                                if( i == _currentPage )
                                  SlideDots(true)
                                else
                                  SlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _currentPage == 2 ?SizedBox(height: 20,):Container(height:20,child: Text("Swipe to learn more", style: TextStyle(color: Theme.of(context).primaryColor),)),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Start Now',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: const EdgeInsets.all(15),
                      color: Theme
                          .of(context)
                          .primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pushNamed("/register");
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}