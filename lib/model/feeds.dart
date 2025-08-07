import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/extension/object.dart';
import '/model/reading_lists.dart';
import 'feed.dart';

enum AdvanceState { notAllRead, allReadAwaitingTomorrow, listsAdvanced }

@lazySingleton
class Feeds with ChangeNotifier {
  final ReadingLists _readingLists;
  final SharedPreferences _sharedPreferences;

  Feeds(this._readingLists, this._sharedPreferences) {
    _feeds = _readingLists.items.map((rl) => Feed(rl)).toList();
    for (Feed f in _feeds) {
      f.addListener(notifyListeners);
    }
  }

  late List<Feed> _feeds;
  final _hasEverAdvancedStoreKey = 'hasEverAdvanced';

  Feed operator [](int i) => _feeds[i];
  bool get areChaptersRead => _feeds.where((feed) => !feed.isChapterRead).isEmpty;
  bool get hasEverAdvanced => _sharedPreferences.getBool(_hasEverAdvancedStoreKey) ?? false;

  Future forceAdvance() async {
    for (Feed f in _feeds) {
      await f.nextChapter();
    }
    _sharedPreferences.setBool(_hasEverAdvancedStoreKey, true);
  }

  Future<AdvanceState> maybeAdvance() async {
    if (!areChaptersRead) return AdvanceState.notAllRead.log();

    final dateModifiedList = _feeds.map((f) => f.dateModified ?? DateTime(0)).toList();
    final latestDateModified = dateModifiedList.reduce((a, b) => a.isAfter(b) ? a : b);
    final now = clock.now(); // use clock (not DateTime) for unit testing
    if (now.day != latestDateModified.day ||
        now.month != latestDateModified.month ||
        now.year != latestDateModified.year) {
      await forceAdvance();
      return AdvanceState.listsAdvanced.log();
    }

    return AdvanceState.allReadAwaitingTomorrow.log();
  }
}
