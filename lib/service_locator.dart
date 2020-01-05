import 'package:akaunt/Service/localstorage_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() async {
  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance);
}