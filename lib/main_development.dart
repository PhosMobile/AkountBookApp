import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/AppState/reducers/app_reducer.dart';
import 'package:akaunt/Resources/app_config.dart';
import 'package:akaunt/main.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
void main(){
  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState(),
    middleware: [],
  );
  var configuredApp = AppConfig(
    appTitle: "Akaunt Book",
    buildFlavor: "Development",
    graphqlAPI: 'http://10.0.2.2:8000',
    child: MyApp(store: store),
  );
  return runApp(configuredApp);
}