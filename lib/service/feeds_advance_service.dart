import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/feed.dart';
import '/model/feeds.dart';
import '/service/feed_advance_state.dart';

@lazySingleton
class FeedsAdvanceService {
  final SharedPreferences _sharedPreferences;
  final Feeds _feeds;

  FeedsAdvanceService(this._sharedPreferences, this._feeds);

  static const _hasEverAdvancedStoreKey = 'hasEverAdvanced';

  bool get hasEverAdvanced => _sharedPreferences.getBool(_hasEverAdvancedStoreKey) ?? false;

  Future<FeedAdvanceState> forceAdvance() async {
    for (Feed f in _feeds) {
      f.advance();
    }
    await _sharedPreferences.setBool(_hasEverAdvancedStoreKey, true);
    return Future.value(FeedAdvanceState.listsAdvanced);
  }

  Future<FeedAdvanceState> maybeAdvance() async {
    if (!_feeds.areChaptersRead) return FeedAdvanceState.notAllRead;
    final lastDateModified = _feeds.lastModifiedFeed?.state.dateModified;
    if (lastDateModified == null) return FeedAdvanceState.notAllRead;
    final now = clock.now(); // Use clock (not DateTime) for tests.
    final lastMidnightOfNow = DateTime(now.year, now.month, now.day);
    final lastMidnightOfLastDateModified = DateTime(
      lastDateModified.year,
      lastDateModified.month,
      lastDateModified.day,
    );
    if (lastMidnightOfNow.isAfter(lastMidnightOfLastDateModified)) return forceAdvance();
    return Future.value(FeedAdvanceState.allReadAwaitingTomorrow);
  }
}
