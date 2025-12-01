import 'package:df_log/df_log.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../model/feeds_advance_state.dart';
import 'app_lifecycle_manager.dart';
import 'feeds_advance_manager.dart';
import 'midnight_manager.dart';

@lazySingleton
class AutoAdvanceManager with ChangeNotifier {
  final AppLifecycleManager _appLifecycleManager;
  final FeedsAdvanceManager _feedsAdvanceManager;
  final MidnightManager _midnightManager;

  AutoAdvanceManager(this._appLifecycleManager, this._feedsAdvanceManager, this._midnightManager) {
    Log.info('ctor');
    _appLifecycleManager.onResume(_maybeAdvance, priority: AppLifecyclePriority.high);
    _midnightManager.addListener(_maybeAdvance);
    _maybeAdvance();
  }

  void _maybeAdvance() {
    Log.info('maybeAdvance');
    if (_feedsAdvanceManager.maybeAdvance() == FeedsAdvanceState.listsAdvanced) {
      notifyListeners();
    }
  }
}
