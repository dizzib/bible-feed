import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/feed.dart';
import '/model/feeds.dart';

enum AdvanceState { notAllRead, allReadAwaitingTomorrow, listsAdvanced }

@lazySingleton
class FeedsAdvanceService {
  final SharedPreferences _sharedPreferences;
  final Feeds _feeds;

  FeedsAdvanceService(this._sharedPreferences, this._feeds);

  static const _hasEverAdvancedStoreKey = 'hasEverAdvanced';

  bool get hasEverAdvanced => _sharedPreferences.getBool(_hasEverAdvancedStoreKey) ?? false;

  Future<AdvanceState> forceAdvance() async {
    for (Feed f in _feeds) {
      f.advance();
    }
    await _sharedPreferences.setBool(_hasEverAdvancedStoreKey, true);
    return AdvanceState.listsAdvanced; //.log();
  }

  Future<AdvanceState> maybeAdvance() async {
    if (!_feeds.areChaptersRead) return AdvanceState.notAllRead; //.log();
    final lastDateModified = _feeds.lastModifiedFeed?.state.dateModified;
    if (lastDateModified == null) return AdvanceState.notAllRead;
    // use clock (not DateTime) for integration tests
    if (clock.now().day > lastDateModified.day) return await forceAdvance();
    if (clock.now().month > lastDateModified.month) return await forceAdvance();
    if (clock.now().year > lastDateModified.year) return await forceAdvance();
    return AdvanceState.allReadAwaitingTomorrow; //.log();
  }
}
