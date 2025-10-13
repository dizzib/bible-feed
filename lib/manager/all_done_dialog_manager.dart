import 'package:injectable/injectable.dart';

import 'feeds_advance_manager.dart';
import 'feeds_service.dart';

@lazySingleton
class AllDoneDialogManager {
  final FeedsService _feedsService;
  final FeedsAdvanceManager _feedsAdvanceManager;

  AllDoneDialogManager(this._feedsAdvanceManager, this._feedsService);

  bool hasShown = false;

  // For onboarding, auto-show dialog only the first time all chapters are read.
  bool get isAutoShow => _feedsService.areChaptersRead && !_feedsAdvanceManager.hasEverAdvanced && !hasShown;
}
