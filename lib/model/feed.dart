import 'package:flutter/foundation.dart';
import '../util/store.dart';
import 'book.dart';
import 'reading_list.dart';

part 'feed_extensions.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList readingList;

  Feed(this.readingList) : _book = readingList[0] { loadState(); notifyListeners(); }

  /// state
  Book _book;
  int _chapter = 1;
  bool _isChapterRead = false;
  DateTime _dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  /// calculated getters
  int get bookIndex => readingList.indexOf(book);
  int get chaptersRead => chapter + (isChapterRead ? 1 : 0) - 1;
  double get progress => readingList.progressTo(bookIndex, chaptersRead);

  /// methods
  void nextChapter() {
    assert(_isChapterRead);
    if (++_chapter > _book.chapterCount) {
      _book = readingList[(bookIndex + 1) % readingList.count];
      _chapter = 1;
    }
    _isChapterRead = false;
    saveState(); notifyListeners();
  }

  void setBookAndChapter(int bookIndex, int chapter) {
    assert(bookIndex >= 0); assert(bookIndex < readingList.count);
    _book = readingList[bookIndex];
    this.chapter = chapter;
    _isChapterRead = false;
    saveState(); notifyListeners();
  }

  void toggleIsChapterRead() {
    _isChapterRead = !_isChapterRead;
    saveState(); notifyListeners();
  }
}
