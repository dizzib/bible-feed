import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/object.dart';
import 'feed.dart';
import 'reading_list.dart';

enum AdvanceState { notAllRead, allReadAwaitingTomorrow, listsAdvanced }

class Feeds with ChangeNotifier {
  Feeds(List<ReadingList> readingLists) : _feeds = readingLists.map((rl) => Feed(rl)).toList() {
    for (Feed f in _feeds) {
      f.addListener(notifyListeners);
    }
  }

  final List<Feed> _feeds;

  /// properties
  Feed operator [](int i) => _feeds[i];
  bool get areChaptersRead => _feeds.where((feed) => !feed.isChapterRead).isEmpty;
  bool get hasEverAdvanced => sl<SharedPreferences>().getBool('hasEverAdvanced') ?? false;

  /// methods
  Future<void> forceAdvance() async {
    for (Feed f in _feeds) {
      await f.nextChapter();
    }
    sl<SharedPreferences>().setBool('hasEverAdvanced', true);
  }

  Future<AdvanceState> maybeAdvance() async {
    if (!areChaptersRead) return AdvanceState.notAllRead.log();

    var dateLastSavedList = _feeds.map((f) => f.dateLastSaved ?? DateTime(0)).toList();
    var latestDateLastSaved = dateLastSavedList.reduce((a, b) => a.isAfter(b) ? a : b);
    final now = clock.now(); // use clock (not DateTime) for unit testing
    if (now.day != latestDateLastSaved.day || now.month != latestDateLastSaved.month || now.year != latestDateLastSaved.year) {
      await forceAdvance();
      return AdvanceState.listsAdvanced.log();
    }

    return AdvanceState.allReadAwaitingTomorrow.log();
  }

  void reload() {
    for (Feed f in _feeds) {
      sl<FeedPersisterService>().loadStateOrDefaults(f);
    }
    notifyListeners();
  }
}
