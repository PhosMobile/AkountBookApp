import 'package:akaunt/Api/BusinessPage/create_business.dart';
import 'package:akaunt/Api/BusinessPage/edit_business.dart';
import 'package:akaunt/Screens/AppSetup.dart';
import 'package:akaunt/Screens/UserPage/dasboard.dart';
import 'package:akaunt/Screens/UserPage/logout.dart';
import 'package:akaunt/Screens/email_sent.dart';
import 'package:akaunt/Service/localstorage_service.dart';
import 'package:akaunt/Widgets/logo_avatar.dart';
import 'package:akaunt/screens/get_started.dart';
import 'package:akaunt/screens/otpVerification.dart';
import 'package:akaunt/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:akaunt/screens/login.dart';
import 'package:akaunt/screens/register.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'AppState/app_state.dart';
import 'Screens/UserPage/switch_business.dart';
import 'Screens/forgot_password.dart';
import 'package:flutter/scheduler.dart';

class MyApp extends StatefulWidget {
  final Store<AppState> store;

  MyApp({this.store});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver, TickerProviderStateMixin{
// Store is just a class that holds your apps State tree.
// AppState is something that we will (but haven't yet) established

  ImageAvatars logo = new ImageAvatars();


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        {
          print("inactive");
          break;
        }
      case AppLifecycleState.paused:
        {
          break;
        }
      default:
        {
          break;
        }
    }
  }


  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Akaunt Book",
        theme: ThemeData(
          primaryColor: Color.fromRGBO(0, 174, 239, 1),
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
          '/user_dashboard': (context) => Dashboard(
                currentTab: 0,
              ),
          '/add_business': (context) => AddBusiness(),
          '/getting_started': (context) => GetStarted(),
          '/switch_account': (context) => SwitchBusiness(),
          '/update_business': (context) => EditBusiness(
                business: widget.store.state.currentBusiness,
              ),
          '/logout': (context) => Logout(),
        },

        home: _getStartupScreen(),
      ),
    );
  }
  Widget _getStartupScreen() {
    var localStorageService = locator<LocalStorageService>();
    if(!localStorageService.hasSignedUp && !localStorageService.hasLoggedIn) {
      return GetStarted();
    }
    if(!localStorageService.hasLoggedIn) {
      return Login();
    }
    return AppSetup();
  }
}
