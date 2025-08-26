import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TogglerService with ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  TogglerService(this._sharedPreferences);

  get _storeKey;

  bool get isEnabled => _sharedPreferences.getBool(_storeKey) ?? true;

  set isEnabled(bool value) {
    _sharedPreferences.setBool(_storeKey, value);
    notifyListeners();
  }
}

@lazySingleton
class HapticTogglerService extends TogglerService {
  HapticTogglerService(super.sharedPreferences);

  @override
  get _storeKey => 'isEnabledHaptic';
}

@lazySingleton
class VerseScopeTogglerService extends TogglerService {
  VerseScopeTogglerService(super.sharedPreferences);

  @override
  get _storeKey => 'isEnabledVerseScopes';
}
