import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class HapticService with ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  HapticService(this._sharedPreferences);

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
