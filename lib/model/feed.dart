import 'package:flutter/foundation.dart';
import 'book.dart';
import 'feed_store.dart';
import 'reading_list.dart';

// Feed manipulates, dispenses and stores a reading-list
class Feed with ChangeNotifier {
  final ReadingList readingList;

  Feed(this.readingList) { _loadStateAndNotifyListeners(); }

  void _loadStateAndNotifyListeners() {
    loadState();
    notifyListeners();
  }

  void _saveStateAndNotifyListeners() {
    saveState();
    notifyListeners();
  }

  // state
  DateTime dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  void nextChapter() {
    var b = readingList.current;
    b.nextChapter();
    if (b.chapter == 1) readingList.nextBook();
    _saveStateAndNotifyListeners();
  }

  void setBookAndChapter(Book book, int chapter) {
    readingList.current.reset();
    readingList.current = book;
    readingList.current.chapter = chapter;
    _saveStateAndNotifyListeners();
  }

  void toggleIsChapterRead() {
    readingList.current.isChapterRead = !readingList.current.isChapterRead;
    _saveStateAndNotifyListeners();
  }
}
