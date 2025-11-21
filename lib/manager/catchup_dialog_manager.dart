import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'catchup_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class CatchupDialogManager with ChangeNotifier {
  final CatchupManager _catchupManager;
  final FeedsManager _feedsManager;

  CatchupDialogManager(this._catchupManager, this._feedsManager) {
    _catchupManager.addListener(() {
      // For onboarding, auto-show dialog if never shown before
      if (!_hasShown) show();
    });
  }

  bool _hasShown = true;

  int get chaptersToRead => _catchupManager.daysBehind * 10 + _feedsManager.chaptersToRead;

  void show() {
    notifyListeners();
    _hasShown = true;
  }
}
