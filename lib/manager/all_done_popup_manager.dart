import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:watch_it/watch_it.dart';

import 'catchup_manager.dart';
import 'popup_manager.dart';
import 'feeds_advance_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class AllDonePopupManager extends PopupManager {
  final CatchupManager _catchupManager;
  final FeedsManager _feedsManager;

  AllDonePopupManager(super._storeService, this._catchupManager, this._feedsManager) {
    _feedsManager.addListener(() {
      if (_feedsManager.areChaptersRead && (!hasCompletedOnboarding || _catchupManager.isBehind)) show(); // auto show
    });
  }

  @override
  String get onboardingStoreKeyFragment => 'allDone';

  // ui props

  @override
  void action() => sl<FeedsAdvanceManager>().advance();

  @override
  String? get actionText => 'Advance now >>';

  @override
  Color getBackgroundColor() => [Colors.green, Colors.yellow, Colors.red][_catchupManager.daysBehindClamped];

  @override
  Color getForegroundColor() => [Colors.white, Colors.black, Colors.white][_catchupManager.daysBehindClamped];

  @override
  String getText() {
    final allDoneAdvanceText = '\n\nLists will automatically advance at midnight or you can advance them now.';
    final allDoneText = 'You are now up to date, feeding and growing in the word of God!$allDoneAdvanceText';
    final catchupAdvanceText = '\n\nAdvance now to catch up.';
    final catchupText = 'You have ${_catchupManager.chaptersToRead} more chapters to read today!$catchupAdvanceText';
    return _catchupManager.isBehind ? catchupText : allDoneText;
  }

  @override
  String get title {
    return _catchupManager.isBehind ? 'Not yet done' : 'All done for today!';
  }
}
