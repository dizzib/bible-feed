import 'package:df_log/df_log.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/feed.dart';
import '/model/feeds.dart';
import 'date_time_service.dart';
import 'feed_advance_service.dart';
import 'feeds_advance_state.dart';

@lazySingleton
class FeedsAdvanceService {
  final DateTimeService _dateTimeService;
  final SharedPreferences _sharedPreferences;
  final FeedAdvanceService _feedAdvanceService;
  final Feeds _feeds;

  FeedsAdvanceService(this._dateTimeService, this._sharedPreferences, this._feedAdvanceService, this._feeds);

  static const _hasEverAdvancedStoreKey = 'hasEverAdvanced';

  bool get hasEverAdvanced => _sharedPreferences.getBool(_hasEverAdvancedStoreKey) ?? false;

  Future<FeedsAdvanceState> forceAdvance() async {
    Log.info('forceAdvance');
    for (Feed f in _feeds) {
      _feedAdvanceService.advance(f);
    }
    await _sharedPreferences.setBool(_hasEverAdvancedStoreKey, true);
    return Future.value(FeedsAdvanceState.listsAdvanced);
  }

  Future<FeedsAdvanceState> maybeAdvance() async {
    Log.info('maybeAdvance');
    if (!_feeds.areChaptersRead) return FeedsAdvanceState.notAllRead;
    Log.info(1);
    final lastDateModified = _feeds.lastModifiedFeed?.state.dateModified;
    Log.info(2);
    if (lastDateModified == null) return FeedsAdvanceState.notAllRead;
    Log.info(3);
    final now = _dateTimeService.now;
    final lastMidnightOfNow = DateTime(now.year, now.month, now.day);
    final lastMidnightOfLastDateModified = DateTime(
      lastDateModified.year,
      lastDateModified.month,
      lastDateModified.day,
    );
    Log.info(lastMidnightOfNow);
    Log.info(lastMidnightOfLastDateModified);
    if (lastMidnightOfNow.isAfter(lastMidnightOfLastDateModified)) return forceAdvance();
    return Future.value(FeedsAdvanceState.allReadAwaitingTomorrow);
  }
}
