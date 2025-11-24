import 'package:flutter/widgets.dart';

import '../service/store_service.dart';

abstract class DialogManager with ChangeNotifier {
  final StoreService _storeService;

  DialogManager(this._storeService);

  //// abstract

  String get onboardingStoreKey;

  //// concrete

  bool get hasCompletedOnboarding => _storeService.getBool(onboardingStoreKey) ?? false;

  String get storeKey => 'hasCompletedOnboarding.$onboardingStoreKey}';

  void show() async {
    await _storeService.setBool(onboardingStoreKey, true);
    notifyListeners();
  }
}
