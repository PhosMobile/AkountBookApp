import 'dart:convert';
import '../service_locator.dart';
import 'package:akaunt/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;
  static const String UserKey = 'user';
  static const String AppLanguagesKey = 'languages';
  static const String DarkModeKey = 'darkmode';
  static const String SignedUpKey = 'signedUp';
  static const String LoggedInKey = 'loggedIn';

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  User get user {
    var userJson = _getFromDisk(UserKey);
    if (userJson == null) {
      return null;
    }

    return User.fromJson(json.decode(userJson));
  }

  set user(User userToSave) {
    saveStringToDisk(UserKey, json.encode(userToSave.toJson()));
  }

  dynamic _getFromDisk(String key) {
    var value  = _preferences.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void saveStringToDisk(String key, String content){
    print('(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
    _preferences.setString(UserKey, content);
    var storageService = locator<LocalStorageService>();
    var mySavedUser = storageService.user;
  }

  bool get darkMode => _getFromDisk(DarkModeKey) ?? false;
  set darkMode(bool value) => _saveToDisk(DarkModeKey, value);

  List<String> get languages => _getFromDisk(AppLanguagesKey) ?? List<String>();
  set languages(List<String> appLanguages) => _saveToDisk(AppLanguagesKey, appLanguages);

  void _saveToDisk<T>(String key, T content){
    print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if(content is String) {
      _preferences.setString(key, content);
    }
    if(content is bool) {
      _preferences.setBool(key, content);
    }
    if(content is int) {
      _preferences.setInt(key, content);
    }
    if(content is double) {
      _preferences.setDouble(key, content);
    }
    if(content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }


  bool get hasSignedUp => _getFromDisk(SignedUpKey) ?? false;
  set hasSignedUp(bool value) => _saveToDisk(SignedUpKey, value);
  bool get hasLoggedIn => _getFromDisk(LoggedInKey) ?? false;
  set hasLoggedIn(bool value) => _saveToDisk(LoggedInKey, value);


}