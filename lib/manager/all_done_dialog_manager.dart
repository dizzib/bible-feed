import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'feeds_advance_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class AllDoneDialogManager with ChangeNotifier {
  final FeedsManager _feedsManager;
  final FeedsAdvanceManager _feedsAdvanceManager;

  AllDoneDialogManager(this._feedsManager, this._feedsAdvanceManager) {
    _feedsManager.addListener(() {
      // For onboarding, auto-show dialog only the first time all chapters are read.
      if (_feedsManager.areChaptersRead && !_feedsAdvanceManager.hasEverAdvanced && !_hasShown) show();
    });
  }

  bool _hasShown = false;

  void show() {
    notifyListeners();
    _hasShown = true;
  }
}
