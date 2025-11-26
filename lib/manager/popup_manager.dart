import 'package:flutter/widgets.dart';

import '../service/store_service.dart';

abstract class PopupManager with ChangeNotifier {
  final StoreService _storeService;

  PopupManager(this._storeService);

  //// abstract

  String getText();
  String get onboardingStoreKeyFragment;
  String get title;

  //// concrete

  String get _onboardingStoreKey => 'hasCompletedOnboarding.$onboardingStoreKeyFragment';

  bool get hasCompletedOnboarding => _storeService.getBool(_onboardingStoreKey) ?? false;

  // ui props

  void action() {}

  String? get actionText => null;

  bool get hasAction => actionText != null;

  Color getBackgroundColor();

  Color getForegroundColor();

  // methods

  void completeOnboarding() => _storeService.setBool(_onboardingStoreKey, true);

  void show() {
    completeOnboarding();
    notifyListeners();
  }
}
