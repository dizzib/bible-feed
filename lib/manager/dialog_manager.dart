import 'package:flutter/widgets.dart';

import '../service/store_service.dart';

abstract class DialogManager with ChangeNotifier {
  final StoreService _storeService;

  DialogManager(this._storeService);

  //// abstract

  String get closeText;
  String Function() get getText;
  String get onboardingStoreKey;
  String get title;

  //// concrete

  String get _onboardingStoreKey => 'hasCompletedOnboarding.$onboardingStoreKey';

  bool get hasCompletedOnboarding => _storeService.getBool(_onboardingStoreKey) ?? false;

  // ui props

  void Function()? get action => null;

  String? get actionText => null;

  bool get hasAction => action != null;

  // methods

  void completeOnboarding() => _storeService.setBool(_onboardingStoreKey, true);

  void show() {
    completeOnboarding();
    notifyListeners();
  }
}
