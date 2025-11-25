import 'package:flutter/material.dart';

import '../service/store_service.dart';

abstract class SettingManager with ChangeNotifier {
  final StoreService _storeService;

  SettingManager(this._storeService);

  //// abstract

  bool get canEnable;
  bool get isEnabledByDefault;
  String get storeKeyFragment;
  String get subtitle;
  String get title;

  //// concrete

  String get _storeKey => 'isEnabled.$storeKeyFragment';

  bool get isEnabled => canEnable && (_storeService.getBool(_storeKey) ?? isEnabledByDefault);

  set isEnabled(bool value) {
    assert(canEnable || !value);
    _storeService.setBool(_storeKey, value);
    notifyListeners();
  }
}
