import 'package:flutter/foundation.dart';
import 'package:cron/cron.dart';
import '../data/store.dart';
import '../util/date.dart';
import 'feed.dart';

class Feeds with ChangeNotifier {
  Feeds(List<Books> bookList) : _feedList = bookList.map((bks) => Feed(bks)).toList() {
    for (var f in _feedList) { f.addListener(() => notifyListeners()); }
    _cron.schedule(Schedule.parse('0 0 * * *'), () async { maybeAdvance(); });
    maybeAdvance();
  }

  /// private
  final Cron _cron = Cron();
  final List<Feed> _feedList;

  /// public
  Feed operator [](int i) => _feedList[i];
  bool get areChaptersRead => _feedList.where((feed) => !feed.books.current.isChapterRead).isEmpty;
  bool? get hasEverAdvanced => Store.getBool('hasEverAdvanced');

  void forceAdvance() {
    for (var f in _feedList) { f.nextChapter(); }
    Store.setBool('hasEverAdvanced', true);
  }

  void maybeAdvance() {
    if (!areChaptersRead) return;
    var savedDates = _feedList.map((f) => f.dateLastSaved).toList();
    var latestSavedDate = savedDates.reduce((a, b) => a.isAfter(b) ? a : b);
    if (!latestSavedDate.isToday) forceAdvance();
  }
}