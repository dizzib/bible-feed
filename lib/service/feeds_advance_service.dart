import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/feeds.dart';
import '/extension/object.dart';
import '/model/feed.dart';

enum AdvanceState { notAllRead, allReadAwaitingTomorrow, listsAdvanced }

@lazySingleton
class FeedsAdvanceService {
  final SharedPreferences _sharedPreferences;
  final Feeds _feeds;

  FeedsAdvanceService(this._sharedPreferences, this._feeds);

  static const _hasEverAdvancedStoreKey = 'hasEverAdvanced';

  bool get hasEverAdvanced => _sharedPreferences.getBool(_hasEverAdvancedStoreKey) ?? false;

  Future forceAdvance() async {
    for (Feed f in _feeds) {
      await f.advance();
    }
    _sharedPreferences.setBool(_hasEverAdvancedStoreKey, true);
  }

  Future<AdvanceState> maybeAdvance() async {
    if (!_feeds.areChaptersRead) return AdvanceState.notAllRead.log();

    final lastDateModified = _feeds.lastModifiedFeed?.state.dateModified;
    final now = clock.now(); // use clock (not DateTime) for unit testing
    if (now.day != lastDateModified?.day ||
        now.month != lastDateModified?.month ||
        now.year != lastDateModified?.year) {
      await forceAdvance();
      return AdvanceState.listsAdvanced.log();
    }

    return AdvanceState.allReadAwaitingTomorrow.log();
  }
}
