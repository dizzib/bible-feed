import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'catchup_manager.dart';
import 'popup_manager.dart';

@lazySingleton
class CatchupPopupManager extends PopupManager {
  final CatchupManager _catchupManager;

  CatchupPopupManager(super._storeService, this._catchupManager) {
    _catchupManager.addListener(() {
      if (_catchupManager.isBehind && !hasCompletedOnboarding) show();
    });
  }

  @override
  String get onboardingStoreKeyFragment => 'catchup';

  //// ui

  @override
  Color Function() get backgroundColor => () => _catchupManager.isVeryBehind ? Colors.red : Colors.yellow.shade100;

  @override
  Color Function() get foregroundColor => () => _catchupManager.isVeryBehind ? Colors.white : Colors.black;

  @override
  String get closeText => 'Close';

  @override
  String Function() get getText => () {
    final daysBehind = _catchupManager.daysBehind;
    return "You have ${_catchupManager.chaptersToRead} chapters to read today, beloved, because you are $daysBehind day${daysBehind == 1 ? '' : 's'} behind!\n\n'Give us this day our daily bread'\nMatthew 6:11";
  };

  @override
  String get title => 'Catchup alert!';
}
