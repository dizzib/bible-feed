import 'package:flutter/foundation.dart';
import '../util/date.dart';
import '../util/store.dart';
import 'feed.dart';
import 'reading_list.dart';

class Feeds with ChangeNotifier {
  final List<Feed> _feeds;

  Feeds(List<ReadingList> readingLists) : _feeds = readingLists.map((rl) => Feed(rl)).toList() {
    for (Feed f in _feeds) { f.addListener(() => notifyListeners()); }
    maybeAdvance();
  }

  /// properties
  Feed operator [](int i) => _feeds[i];
  bool get areChaptersRead => _feeds.where((feed) => !feed.isChapterRead).isEmpty;
  bool get hasEverAdvanced => Store.getBool('hasEverAdvanced') ?? false;
  int get length => _feeds.length;

  /// methods
  void forceAdvance() {
    for (Feed f in _feeds) { f.nextChapter(); }
    Store.setBool('hasEverAdvanced', true);
  }

  // return codes for debugging:
  //   1 - not all chapters read
  //   2 - all chapters read but still today
  //   3 - advanced lists
  int maybeAdvance() {
    if (!areChaptersRead) return 1;
    var savedDates = _feeds.map((f) => f.dateLastSaved ?? DateTime(0)).toList();
    var latestSavedDate = savedDates.reduce((a, b) => a.isAfter(b) ? a : b);
    if (!latestSavedDate.isToday) { forceAdvance(); return 3; }
    return 2;
  }
}
