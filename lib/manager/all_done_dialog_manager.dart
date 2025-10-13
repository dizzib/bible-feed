import 'package:injectable/injectable.dart';

import 'feeds_advance_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class AllDoneDialogManager {
  final FeedsManager _feedsManager;
  final FeedsAdvanceManager _feedsAdvanceManager;

  AllDoneDialogManager(this._feedsAdvanceManager, this._feedsManager);

  bool hasShown = false;

  // For onboarding, auto-show dialog only the first time all chapters are read.
  bool get isAutoShow => _feedsManager.areChaptersRead && !_feedsAdvanceManager.hasEverAdvanced && !hasShown;
}
