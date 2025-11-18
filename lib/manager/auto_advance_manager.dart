import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../model/feeds_advance_state.dart';
import 'feeds_advance_manager.dart';
import 'midnight_manager.dart';

@lazySingleton
class AutoAdvanceManager with ChangeNotifier {
  final FeedsAdvanceManager _feedsAdvanceManager;
  final MidnightManager _midnightManager;

  AutoAdvanceManager(this._feedsAdvanceManager, this._midnightManager) {
    AppLifecycleListener(onResume: _feedsAdvanceManager.maybeAdvance);

    _feedsAdvanceManager.maybeAdvance();

    _midnightManager.addListener(() async {
      if (await _feedsAdvanceManager.maybeAdvance() == FeedsAdvanceState.listsAdvanced) {
        notifyListeners();
      }
    });
  }
}
