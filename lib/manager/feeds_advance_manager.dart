import 'package:df_log/df_log.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import '../model/feeds_advance_state.dart';
import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'feed_advance_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class FeedsAdvanceManager with ChangeNotifier {
  final DateTimeService _dateTimeService;
  final FeedAdvanceManager _feedAdvanceManager;
  final FeedsManager _feedsManager;
  final StoreService _storeService;

  FeedsAdvanceManager(this._dateTimeService, this._feedAdvanceManager, this._feedsManager, this._storeService);

  static const _lastAdvanceDateStoreKey = 'lastAdvanceDate';

  bool get hasEverAdvanced => lastAdvanceDate != null;
  DateTime? get lastAdvanceDate => _storeService.getDateTime(_lastAdvanceDateStoreKey);

  Future<FeedsAdvanceState> advance() async {
    for (Feed f in _feedsManager.feeds) {
      _feedAdvanceManager.advance(f);
    }
    await _storeService.setDateTime(_lastAdvanceDateStoreKey, _dateTimeService.now);
    notifyListeners();
    return FeedsAdvanceState.listsAdvanced;
  }

  Future<FeedsAdvanceState> maybeAdvance() async {
    if (!_feedsManager.areChaptersRead) return FeedsAdvanceState.notAllRead;
    final lastDateModified = _feedsManager.lastModifiedFeed?.state.dateModified;
    if (lastDateModified == null) return FeedsAdvanceState.notAllRead;
    final now = _dateTimeService.now;
    Log.info(now);
    final lastMidnightOfNow = DateTime(now.year, now.month, now.day);
    final lastMidnightOfLastDateModified = DateTime(
      lastDateModified.year,
      lastDateModified.month,
      lastDateModified.day,
    );
    Log.info(lastMidnightOfNow);
    Log.info(lastMidnightOfLastDateModified);
    if (lastMidnightOfNow.isAfter(lastMidnightOfLastDateModified)) return advance();
    return FeedsAdvanceState.allReadAwaitingTomorrow;
  }
}
