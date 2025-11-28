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
  Color getBackgroundColor() => _catchupManager.isVeryBehind ? Colors.red : Colors.yellow;

  @override
  Color getForegroundColor() => _catchupManager.isVeryBehind ? Colors.white : Colors.black;

  @override
  String getText() {
    assert(_catchupManager.isBehind);
    final chaptersToRead = _catchupManager.chaptersToRead;
    final daysBehind = "${_catchupManager.daysBehind} day${_catchupManager.daysBehind == 1 ? '' : 's'}";
    final alert = "You have $chaptersToRead chapters to read today, because you are now $daysBehind behind.";
    final exhortation = 'Beloved, do not neglect to feed daily upon the word of God, for it is written...';
    return '$alert\n\n$exhortation';
  }

  @override
  String get title => 'Catch Up!';

  @override
  List<Verse>? get verses => [
    Verse(
      text: 'as newborn babes, desire the pure milk of the word, that you may grow thereby',
      reference: '1 Peter 2:2 NKJV',
    ),
    Verse(text: 'Give us this day our daily bread', reference: 'Matthew 6:11 KJV'),
  ];
}
