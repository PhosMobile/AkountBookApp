import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/AppState/reducers/app_reducer.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'Resources/app_config.dart';
import 'main.dart';

void main(){
  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState(),
    middleware: [],
  );

  var configuredApp = AppConfig(
    appTitle: "Akount Book Development",
    buildFlavor: "Development",
    graphqlAPI: 'http://10.0.2.2:8000',
    child: MyApp(store: store),
  );
  return runApp(configuredApp);
}