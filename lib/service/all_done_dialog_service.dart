import 'package:injectable/injectable.dart';

import '/model/feeds.dart';
import 'feeds_advance_service.dart';

@lazySingleton
class AllDoneDialogService {
  final Feeds _feeds;
  final FeedsAdvanceService _feedsAdvanceService;

  AllDoneDialogService(this._feedsAdvanceService, this._feeds);

  bool _hasShown = false;

  // for onboarding, auto-show dialog only the first time all chapters are read
  bool get isAutoShow => _feeds.areChaptersRead && !_feedsAdvanceService.hasEverAdvanced && !_hasShown;

  set hasShown(bool value) => _hasShown = value;
}
