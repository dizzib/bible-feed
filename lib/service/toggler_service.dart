import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TogglerService with ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  TogglerService(this._sharedPreferences);

  String get _storeKey;
  String get title;
  String get subtitle;

  bool get isEnabled => _sharedPreferences.getBool(_storeKey) ?? false;

  set isEnabled(bool value) {
    _sharedPreferences.setBool(_storeKey, value);
    notifyListeners();
  }
}

@lazySingleton
class HapticTogglerService extends TogglerService {
  HapticTogglerService(super.sharedPreferences);

  @override
  get _storeKey => 'isEnabled.haptic';

  @override
  String get title => 'Interaction';

  @override
  String get subtitle => 'Vibrate on tap or scroll.';
}

@lazySingleton
class VerseScopeTogglerService extends TogglerService {
  VerseScopeTogglerService(super.sharedPreferences);

  @override
  get _storeKey => 'isEnabled.verseScopes';

  @override
  String get title => 'Split Chapters';

  @override
  String get subtitle => 'Split long chapters, such as Psalm 119, into smaller sections.';
}
