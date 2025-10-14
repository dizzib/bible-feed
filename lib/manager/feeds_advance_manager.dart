import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import '../model/feeds_advance_state.dart';
import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'feed_advance_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class FeedsAdvanceManager {
  final DateTimeService _dateTimeService;
  final StoreService _storeService;
  final FeedAdvanceManager _feedAdvanceManager;
  final FeedsManager _feedsManager;

  FeedsAdvanceManager(this._dateTimeService, this._storeService, this._feedAdvanceManager, this._feedsManager);

  static const _hasEverAdvancedStoreKey = 'hasEverAdvanced';

  bool get hasEverAdvanced => _storeService.getBool(_hasEverAdvancedStoreKey) ?? false;

  Future<FeedsAdvanceState> advance() async {
    for (Feed f in _feedsManager.feeds) {
      _feedAdvanceManager.advance(f);
    }
    await _storeService.setBool(_hasEverAdvancedStoreKey, true);
    return Future.value(FeedsAdvanceState.listsAdvanced);
  }

  Future<FeedsAdvanceState> maybeAdvance() async {
    if (!_feedsManager.areChaptersRead) return FeedsAdvanceState.notAllRead;
    final lastDateModified = _feedsManager.lastModifiedFeed?.state.dateModified;
    if (lastDateModified == null) return FeedsAdvanceState.notAllRead;
    final now = _dateTimeService.now;
    final lastMidnightOfNow = DateTime(now.year, now.month, now.day);
    final lastMidnightOfLastDateModified = DateTime(
      lastDateModified.year,
      lastDateModified.month,
      lastDateModified.day,
    );
    if (lastMidnightOfNow.isAfter(lastMidnightOfLastDateModified)) return advance();
    return Future.value(FeedsAdvanceState.allReadAwaitingTomorrow);
  }
}
