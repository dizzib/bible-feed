import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../model/verse.dart';
import 'catchup_manager.dart';
import 'popup_manager.dart';

@lazySingleton
class CatchupPopupManager extends PopupManager {
  final CatchupManager _catchupManager;

  CatchupPopupManager(super._storeService, this._catchupManager) {
    _catchupManager.addListener(() {
      if (_catchupManager.isBehind && !hasCompletedOnboarding) show(); // auto show
    });
  }

  @override
  String get onboardingStoreKeyFragment => 'catchup';

  //// ui

  @override
  Color getBackgroundColor() => _catchupManager.isVeryBehind ? Colors.red : Colors.yellow.shade100;

  @override
  Color getForegroundColor() => _catchupManager.isVeryBehind ? Colors.white : Colors.black;

  @override
  String getText() {
    final daysBehind = _catchupManager.daysBehind;
    return "You have ${_catchupManager.chaptersToRead} chapters to read today, beloved, because you are now $daysBehind day${daysBehind == 1 ? '' : 's'} behind!";
  }

  @override
  String get title => 'Catchup!';

  @override
  List<Verse>? get verses => [Verse(text: 'Give us this day our daily bread', reference: 'Matthew 6:11')];
}
