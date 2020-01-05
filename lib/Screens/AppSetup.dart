import 'package:akaunt/Api/UserAcount/logged_in_user.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Widgets/logo_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSetup extends StatefulWidget {
  @override
  _AppSetupState createState() => _AppSetupState();
}

class _AppSetupState extends State<AppSetup> with TickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;
  ImageAvatars logo = new ImageAvatars();

  @override
  void initState() {
    animController = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this)
      ..repeat(reverse: true);
    animation =
        CurvedAnimation(parent: animController, curve: Curves.easeInOut);
    super.initState();
  }
  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInitialBuild: (state) async {
        if(state.loggedInUser == null){
          final prefs = await SharedPreferences.getInstance();
          final LocalStorage storage = new LocalStorage('some_key');
          String accessToken = prefs.getString("access_token");
          storage.setItem("access_token", accessToken);
          await LoggedInUser().fetchLoggedInUser(context, "");
          Navigator.pushNamed(context, "/user_dashboard");
        }
      },
      builder: (context, state) {
        return Container(
            color: Colors.white,
            child: FadeTransition(
                opacity: animation,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  logo.miniLogoAvatar(),
                ])));
      },
    );
  }
}
