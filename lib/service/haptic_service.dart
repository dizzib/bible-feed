import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class HapticService extends RouteObserver<PageRoute<dynamic>> with ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  HapticService(this._sharedPreferences);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => impact();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => impact();

  static const _storeKey = 'isEnableHaptic';

  bool get isEnabled => _sharedPreferences.getBool(_storeKey) ?? true;

  set isEnabled(bool value) {
    _sharedPreferences.setBool(_storeKey, value);
    notifyListeners();
  }

  void impact() {
    if (isEnabled) HapticFeedback.lightImpact();
  }
}
