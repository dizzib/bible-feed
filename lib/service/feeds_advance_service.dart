import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/feed.dart';
import '/model/feeds.dart';
import 'date_time_service.dart';
import 'feeds_advance_state.dart';

@lazySingleton
class FeedsAdvanceService {
  final DateTimeService _dateTimeService;
  final SharedPreferences _sharedPreferences;
  final Feeds _feeds;

  FeedsAdvanceService(this._dateTimeService, this._sharedPreferences, this._feeds);

  static const _hasEverAdvancedStoreKey = 'hasEverAdvanced';

  bool get hasEverAdvanced => _sharedPreferences.getBool(_hasEverAdvancedStoreKey) ?? false;

  Future<FeedsAdvanceState> forceAdvance() async {
    for (Feed f in _feeds) {
      f.advance();
    }
    await _sharedPreferences.setBool(_hasEverAdvancedStoreKey, true);
    return Future.value(FeedsAdvanceState.listsAdvanced);
  }

  Future<FeedsAdvanceState> maybeAdvance() async {
    if (!_feeds.areChaptersRead) return FeedsAdvanceState.notAllRead;
    final lastDateModified = _feeds.lastModifiedFeed?.state.dateModified;
    if (lastDateModified == null) return FeedsAdvanceState.notAllRead;
    final now = _dateTimeService.now;
    final lastMidnightOfNow = DateTime(now.year, now.month, now.day);
    final lastMidnightOfLastDateModified = DateTime(
      lastDateModified.year,
      lastDateModified.month,
      lastDateModified.day,
    );
    if (lastMidnightOfNow.isAfter(lastMidnightOfLastDateModified)) return forceAdvance();
    return Future.value(FeedsAdvanceState.allReadAwaitingTomorrow);
  }
}
