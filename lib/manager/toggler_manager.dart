import 'package:flutter/material.dart';

import '../service/store_service.dart';

abstract class TogglerManager with ChangeNotifier {
  final StoreService _storeService;

  TogglerManager(this._storeService);

  bool get canEnable;
  String get storeKey;
  String get subtitle;
  String get title;

  bool get isEnabled => canEnable && (_storeService.getBool(storeKey) ?? false);

  set isEnabled(bool value) {
    assert(canEnable || !value);
    _storeService.setBool(storeKey, value);
    notifyListeners();
  }
}
