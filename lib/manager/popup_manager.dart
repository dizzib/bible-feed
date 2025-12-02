import 'package:flutter/widgets.dart';

import '../model/verse.dart';
import '../service/store_service.dart';

abstract class PopupManager with ChangeNotifier {
  final StoreService _storeService;

  PopupManager(this._storeService);

  //// abstract

  String getText();
  String get onboardingStoreKeyFragment;
  String get title;

  void action();
  Icon get actionIcon;
  String get actionKey;
  String get actionText;

  Color getBackgroundColor();
  Color getForegroundColor();

  //// concrete

  String get _onboardingStoreKey => 'hasCompletedOnboarding.$onboardingStoreKeyFragment';
  bool get hasAction => actionKey != '';
  bool get hasCompletedOnboarding => _storeService.getBool(_onboardingStoreKey) ?? false;
  List<Verse>? get verses => null;

  void completeOnboarding() => _storeService.setBool(_onboardingStoreKey, true);

  void show() {
    completeOnboarding();
    notifyListeners();
  }
}
