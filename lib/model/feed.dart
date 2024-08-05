import 'package:flutter/foundation.dart';
import 'book.dart';
import 'feed_store.dart';
import 'reading_list.dart';

// Feed manipulates and persists state of a reading-list
class Feed with ChangeNotifier {
  final ReadingList readingList;

  Feed(this.readingList) {
    loadState();
    notifyListeners();
  }

  void _saveStateAndNotifyListeners() {
    saveState();
    notifyListeners();
  }

  // state
  int _index = 0;  // current book index
  DateTime dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  /// properties
  Book get current => readingList[_index];
  set current(Book b) => _index = readingList.indexOf(b);
  double get progress => readingList.progressTo(current, current.chaptersRead);

  /// methods

  void nextBook() { _index = ++_index % readingList.count; }

  void nextChapter() {
    var b = current;
    b.nextChapter();
    if (b.chapter == 1) nextBook();
    _saveStateAndNotifyListeners();
  }

  void setBookAndChapter(Book book, int chapter) {
    current.reset();
    current = book;
    current.chapter = chapter;
    _saveStateAndNotifyListeners();
  }

  void toggleIsChapterRead() {
    current.isChapterRead = !current.isChapterRead;
    _saveStateAndNotifyListeners();
  }
}
