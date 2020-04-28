import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/AppState/reducers/app_reducer.dart';
import 'package:akaunt/Resources/app_config.dart';
import 'package:akaunt/main.dart';
import 'package:akaunt/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState(),
    middleware: [],
  );

  var configuredApp = AppConfig(
    appTitle: "Akaunt Book",
    buildFlavor: "Production",
    apiEndpoint: 'https://akauntbook-api.herokuapp.com',
    child: MyApp(store: store),
  );
  try {
    setupLocator();
    return runApp(configuredApp);
  } catch(error) {
    print('Locator setup has failed');
    print(error);
  }
}