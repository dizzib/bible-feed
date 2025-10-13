import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/feed.dart';
import '../service/date_time_service.dart';
import 'feed_advance_service.dart';
import 'feeds_advance_state.dart';
import 'feeds_service.dart';

@lazySingleton
class FeedsAdvanceService {
  final DateTimeService _dateTimeService;
  final SharedPreferences _sharedPreferences;
  final FeedAdvanceService _feedAdvanceService;
  final FeedsService _feedsService;

  FeedsAdvanceService(this._dateTimeService, this._sharedPreferences, this._feedAdvanceService, this._feedsService);

  static const _hasEverAdvancedStoreKey = 'hasEverAdvanced';

  bool get hasEverAdvanced => _sharedPreferences.getBool(_hasEverAdvancedStoreKey) ?? false;

  Future<FeedsAdvanceState> advance() async {
    for (Feed f in _feedsService.feeds) {
      _feedAdvanceService.advance(f);
    }
    await _sharedPreferences.setBool(_hasEverAdvancedStoreKey, true);
    return Future.value(FeedsAdvanceState.listsAdvanced);
  }

  Future<FeedsAdvanceState> maybeAdvance() async {
    if (!_feedsService.areChaptersRead) return FeedsAdvanceState.notAllRead;
    final lastDateModified = _feedsService.lastModifiedFeed?.state.dateModified;
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
