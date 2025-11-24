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

  bool get hasCompletedOnboarding => _storeService.getBool(onboardingStoreKey) ?? false;

  // ui props

  void Function()? get action => null;

  String? get actionText => null;

  bool get hasAction => action != null;

  String get storeKey => 'hasCompletedOnboarding.$onboardingStoreKey}';

  // methods

  void show() async {
    await _storeService.setBool(onboardingStoreKey, true);
    notifyListeners();
  }
}
