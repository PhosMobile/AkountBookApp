import 'package:akount_books/Api/BusinessPage/add_business.dart';
import 'package:akount_books/Screens/UserPage/dasboard.dart';
import 'package:akount_books/Screens/UserPage/logout.dart';
import 'package:akount_books/Screens/email_sent.dart';
import 'package:akount_books/screens/get_started.dart';
import 'package:akount_books/screens/otpVerification.dart';
import 'package:flutter/material.dart';
import 'package:akount_books/screens/home.dart';
import 'package:akount_books/screens/login.dart';
import 'package:akount_books/screens/register.dart';
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
        title: "Akount Book",
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
          '/get-started': (context) => GetStarted(),
          '/otp_verifiy': (context) => OTPVerification(),
          '/complete_registraton': (context) => OTPVerification(),
          '/forgot_password': (context) => ForgotPassword(),
          '/email_sent': (context) => EmailSent(),
          '/user_dashboard': (context) => Dashboard(),
          '/add_business': (context) => AddBusiness(),
          '/switch_account': (context) => SwitchBusiness(),
          '/logout': (context) => Logout(),
        },
        home: Home(),
      ),
    );
  }
}
