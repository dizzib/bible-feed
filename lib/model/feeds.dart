import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import '/util/date.dart';
import '/util/log.dart';
import 'feed.dart';
import 'reading_list.dart';

enum AdvanceState { notAllRead, allReadAwaitingTomorrow, listsAdvanced }

class Feeds with ChangeNotifier {
  final List<Feed> _feeds;

  Feeds(List<ReadingList> readingLists) : _feeds = readingLists.map((rl) => Feed(rl)).toList() {
    for (Feed f in _feeds) {
      f.persister.addListener(notifyListeners);
    }
  }

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
    var savedDates = _feeds.map((f) => f.dateLastSaved ?? DateTime(0)).toList();
    var latestSavedDate = savedDates.reduce((a, b) => a.isAfter(b) ? a : b);
    if (!latestSavedDate.isToday) {
      await forceAdvance();
      return AdvanceState.listsAdvanced.log();
    }
    return AdvanceState.allReadAwaitingTomorrow.log();
  }

  reload() {
    for (Feed f in _feeds) {
      f.persister.loadStateOrDefaults();
    }
  }
}
