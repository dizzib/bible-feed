import 'package:flutter/foundation.dart';
import 'package:cron/cron.dart';
import '../util/date.dart';
import '../util/store.dart';
import 'feed.dart';
import 'reading_list.dart';

class Feeds with ChangeNotifier {
  final _cron = Cron();
  final List<Feed> _feeds;

  Feeds(List<ReadingList> readingLists) : _feeds = readingLists.map((rl) => Feed(rl)).toList() {
    for (Feed f in _feeds) { f.addListener(() => notifyListeners()); }
    _cron.schedule(Schedule.parse('0 0 * * *'), () async { maybeAdvance(); });
    maybeAdvance();
  }

  /// properties
  Feed operator [](int i) => _feeds[i];
  bool get areChaptersRead => _feeds.where((feed) => !feed.isChapterRead).isEmpty;
  bool get hasEverAdvanced => Store.getBool('hasEverAdvanced') ?? false;

  /// methods
  void forceAdvance() {
    for (Feed f in _feeds) { f.nextChapter(); }
    Store.setBool('hasEverAdvanced', true);
  }

  void maybeAdvance() {
    if (!areChaptersRead) return;
    var savedDates = _feeds.map((f) => f.dateLastSaved ?? DateTime(0)).toList();
    var latestSavedDate = savedDates.reduce((a, b) => a.isAfter(b) ? a : b);
    if (!latestSavedDate.isToday) forceAdvance();
  }
}
