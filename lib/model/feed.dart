import 'package:flutter/foundation.dart';
import 'book.dart';
import 'feed_store.dart';
import 'reading_list.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList readingList;

  Feed(this.readingList) : book = readingList[0] { loadState(); notifyListeners(); }

  /// state
  Book book;
  int chapter = 1;
  bool isChapterRead = false;
  DateTime dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  /// properties
  int get bookIndex => readingList.indexOf(book);
  int get chaptersRead => chapter + (isChapterRead ? 1 : 0) - 1;
  double get progress => readingList.progressTo(bookIndex, chaptersRead);

  /// methods
  void _nextBook() {
    book = readingList[(readingList.indexOf(book) + 1) % readingList.count];
  }

  void nextChapter() {
    assert(isChapterRead);
    if (++chapter > book.chapterCount) { chapter = 1; _nextBook(); }
    isChapterRead = false;
    saveState(); notifyListeners();
  }

  void setBookAndChapter(int bookIndex, int chapter) {
    book = readingList[bookIndex];
    this.chapter = chapter;
    isChapterRead = false;
    saveState(); notifyListeners();
  }

  void toggleIsChapterRead() {
    isChapterRead = !isChapterRead;
    saveState(); notifyListeners();
  }
}
