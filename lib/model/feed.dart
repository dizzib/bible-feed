import 'package:flutter/foundation.dart';
import 'book.dart';
import 'feed_store.dart';
import 'reading_list.dart';

// Feed manages the reading state of a given list of books
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
  int chapter = 1;
  bool isChapterRead = false;
  DateTime dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  /// properties
  int get chaptersRead => chapter + (isChapterRead ? 1 : 0) - 1;
  double get progress => readingList.progressTo(current, chaptersRead);

  /// methods

  void nextBook() {
    int index = readingList.indexOf(current);
    index = ++index % readingList.count;
    current = readingList[index];
  }

  void nextChapter() {
    assert(isChapterRead);
    if (++chapter > current.chapterCount) { chapter = 1; nextBook(); }
    isChapterRead = false;
    _saveStateAndNotifyListeners();
  }

  void setBookAndChapter(Book book, int chapter) {
    // current.reset();
    current = book;
    this.chapter = chapter;
    isChapterRead = false;
    _saveStateAndNotifyListeners();
  }

  void toggleIsChapterRead() {
    isChapterRead = !isChapterRead;
    _saveStateAndNotifyListeners();
  }
}
