import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TogglerService with ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  TogglerService(this._sharedPreferences);

  bool get canEnable;
  String get storeKey;
  String get subtitle;
  String get title;

  bool get isEnabled => canEnable && (_sharedPreferences.getBool(storeKey) ?? false);

  set isEnabled(bool value) {
    _sharedPreferences.setBool(storeKey, value);
    notifyListeners();
  }
}
