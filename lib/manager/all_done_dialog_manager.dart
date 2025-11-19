import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'all_done_manager.dart';
import 'feeds_advance_manager.dart';

@lazySingleton
class AllDoneDialogManager with ChangeNotifier {
  final AllDoneManager _allDoneManager;
  final FeedsAdvanceManager _feedsAdvanceManager;

  AllDoneDialogManager(this._allDoneManager, this._feedsAdvanceManager) {
    _allDoneManager.addListener(() {
      // For onboarding, auto-show dialog only the first time all chapters are read.
      if (!_feedsAdvanceManager.hasEverAdvanced && !_hasShown) show();
    });
  }

  bool _hasShown = false;

  void show() {
    notifyListeners();
    _hasShown = true;
  }
}
