import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'haptic_toggler_service.dart';
part 'verse_scope_toggler_service.dart';

abstract class TogglerService with ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  TogglerService(this._sharedPreferences);

  String get _storeKey;
  String get title;
  String get subtitle;
  bool get isAvailable;

  bool get isEnabled => _sharedPreferences.getBool(_storeKey) ?? false;

  set isEnabled(bool value) {
    _sharedPreferences.setBool(_storeKey, value);
    notifyListeners();
  }
}
