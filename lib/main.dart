import 'package:akaunt/Api/BusinessPage/create_business.dart';
import 'package:akaunt/Api/BusinessPage/edit_business.dart';
import 'package:akaunt/Screens/UserPage/dasboard.dart';
import 'package:akaunt/Screens/UserPage/logout.dart';
import 'package:akaunt/Screens/email_sent.dart';
import 'package:akaunt/screens/get_started.dart';
import 'package:akaunt/screens/otpVerification.dart';
import 'package:flutter/material.dart';
import 'package:akaunt/screens/home.dart';
import 'package:akaunt/screens/login.dart';
import 'package:akaunt/screens/register.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'AppState/app_state.dart';
import 'Screens/UserPage/switch_business.dart';
import 'Screens/forgot_password.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Store<AppState> store;
  MyApp({this.store});
  // Store is just a class that holds your apps State tree.
  // AppState is something that we will (but haven't yet) established
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Akaunt Book",
        theme: ThemeData(
          primaryColor: Color.fromRGBO(4, 100, 183, 1),
          accentColor: Color.fromRGBO(200, 228, 253, 1),
          primaryColorLight: Color.fromRGBO(200, 228, 253, 0.5),
          cardColor: Colors.transparent,
          fontFamily: 'RobotoFont',
        ),
        initialRoute: "/",
        routes: {
          '/register': (context) => Register(),
          '/login': (context) => Login(),
          '/otp_verifiy': (context) => OTPVerification(),
          '/complete_registraton': (context) => OTPVerification(),
          '/forgot_password': (context) => ForgotPassword(),
          '/email_sent': (context) => EmailSent(),
          '/user_dashboard': (context) => Dashboard(currentTab: 0,),
          '/add_business': (context) => AddBusiness(),
          '/switch_account': (context) => SwitchBusiness(),
          '/update_business': (context) => EditBusiness(business: store.state.currentBusiness,),
          '/logout': (context) => Logout(),
        },
        home: GetStarted(),
      ),
    );
  }
}
