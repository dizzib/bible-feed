import 'package:flutter/foundation.dart';
import 'book.dart';
import 'feed_store.dart';
import 'reading_list.dart';

// Feed manages the current reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList readingList;

  Feed(this.readingList) : current = readingList[0] {
    loadState();
    notifyListeners();
  }

  void _saveStateAndNotifyListeners() {
    saveState();
    notifyListeners();
  }

  // state
  Book current;
  DateTime dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  /// properties
  double get progress => readingList.progressTo(current, current.chaptersRead);

  /// methods

  void nextBook() {
    int index = readingList.indexOf(current);
    index = ++index % readingList.count;
    current = readingList[index];
  }

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
