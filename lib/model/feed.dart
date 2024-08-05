import 'package:flutter/foundation.dart';
import 'book.dart';
import 'feed_store.dart';
import 'reading_list.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList readingList;

  Feed(this.readingList) : book = readingList[0] {
    loadState();
    notifyListeners();
  }

  void _saveStateAndNotifyListeners() {
    saveState();
    notifyListeners();
  }

  // state
  Book book;
  int chapter = 1;
  bool isChapterRead = false;
  DateTime dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  /// properties
  int get bookIndex => readingList.indexOf(book);
  int get chaptersRead => chapter + (isChapterRead ? 1 : 0) - 1;
  double get progress => readingList.progressTo(book, chaptersRead);

  /// methods

  void nextBook() {
    int index = readingList.indexOf(book);
    index = ++index % readingList.count;
    book = readingList[index];
  }

  void nextChapter() {
    assert(isChapterRead);
    if (++chapter > book.chapterCount) { chapter = 1; nextBook(); }
    isChapterRead = false;
    _saveStateAndNotifyListeners();
  }

  void setBookAndChapter(Book book, int chapter) {
    this.book = book;
    this.chapter = chapter;
    isChapterRead = false;
    _saveStateAndNotifyListeners();
  }

  void toggleIsChapterRead() {
    isChapterRead = !isChapterRead;
    _saveStateAndNotifyListeners();
  }
}
