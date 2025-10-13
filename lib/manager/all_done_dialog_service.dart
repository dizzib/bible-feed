import 'package:injectable/injectable.dart';

import 'feeds_advance_service.dart';
import 'feeds_service.dart';

@lazySingleton
class AllDoneDialogService {
  final FeedsService _feedsService;
  final FeedsAdvanceService _feedsAdvanceService;

  AllDoneDialogService(this._feedsAdvanceService, this._feedsService);

  bool hasShown = false;

  // For onboarding, auto-show dialog only the first time all chapters are read.
  bool get isAutoShow => _feedsService.areChaptersRead && !_feedsAdvanceService.hasEverAdvanced && !hasShown;
}
