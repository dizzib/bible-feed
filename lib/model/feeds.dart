import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/feed_store_service.dart';
import '/extension/object.dart';
import '/model/reading_lists.dart';
import '/service/verse_scope_service.dart';
import 'feed.dart';

enum AdvanceState { notAllRead, allReadAwaitingTomorrow, listsAdvanced }

@lazySingleton
class Feeds with ChangeNotifier {
  final FeedStoreService _feedStoreService;
  final SharedPreferences _sharedPreferences;
  final VerseScopeService _verseScopeService;

  Feeds(this._feedStoreService, this._verseScopeService, this._sharedPreferences, this._readingLists) {
    _feeds = _readingLists.items.map((rl) => Feed(rl, _verseScopeService, _feedStoreService.loadState(rl))).toList();
    for (Feed f in _feeds) {
      f.addListener(() {
        _lastModifiedFeed = f;
        _feedStoreService.saveState(f);
        notifyListeners();
      });
    }
  }

  final ReadingLists _readingLists;

  late List<Feed> _feeds;
  final _hasEverAdvancedStoreKey = 'hasEverAdvanced';
  Feed? _lastModifiedFeed;

  Feed operator [](int i) => _feeds[i];
  bool get areChaptersRead => _feeds.where((feed) => !feed.state.isRead).isEmpty;
  bool get hasEverAdvanced => _sharedPreferences.getBool(_hasEverAdvancedStoreKey) ?? false;
  Feed? get lastModifiedFeed => _lastModifiedFeed;

  Future forceAdvance() async {
    for (Feed f in _feeds) {
      await f.advance();
    }
    _sharedPreferences.setBool(_hasEverAdvancedStoreKey, true);
  }

  Future<AdvanceState> maybeAdvance() async {
    if (!areChaptersRead) return AdvanceState.notAllRead.log();

    final latestDateModified = _lastModifiedFeed?.state.dateModified;
    final now = clock.now(); // use clock (not DateTime) for unit testing
    if (now.day != latestDateModified?.day ||
        now.month != latestDateModified?.month ||
        now.year != latestDateModified?.year) {
      await forceAdvance();
      return AdvanceState.listsAdvanced.log();
    }

    return AdvanceState.allReadAwaitingTomorrow.log();
  }
}
