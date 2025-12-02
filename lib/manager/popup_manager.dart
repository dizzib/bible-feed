import 'package:flutter/widgets.dart';

import '../model/popup_action.dart';
import '../model/verse.dart';
import '../service/store_service.dart';

abstract class PopupManager with ChangeNotifier {
  final StoreService _storeService;

  PopupManager(this._storeService);

  //// abstract

  String get onboardingStoreKeyFragment;

  /// ui
  PopupAction? get popupAction;
  String get title;
  Color getBackgroundColor();
  Color getForegroundColor();
  String getText();

  //// concrete

  String get _onboardingStoreKey => 'hasCompletedOnboarding.$onboardingStoreKeyFragment';
  bool get hasCompletedOnboarding => _storeService.getBool(_onboardingStoreKey) ?? false;
  List<Verse>? get verses => null;

  void completeOnboarding() => _storeService.setBool(_onboardingStoreKey, true);

  void show() {
    completeOnboarding();
    notifyListeners();
  }
}
