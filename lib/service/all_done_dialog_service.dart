import 'package:injectable/injectable.dart';

import '/model/feeds.dart';
import 'feeds_advance_service.dart';

@lazySingleton
class AllDoneDialogService {
  final Feeds _feeds;
  final FeedsAdvanceService _feedsAdvanceService;

  AllDoneDialogService(this._feedsAdvanceService, this._feeds);

  bool _isAlreadyShown = false;

  // auto-show dialog once only
  bool get isAutoShow => _feeds.areChaptersRead && !_feedsAdvanceService.hasEverAdvanced && !_isAlreadyShown;

  set isAlreadyShown(bool value) => _isAlreadyShown = value;
}
