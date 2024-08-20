import 'package:flutter/foundation.dart';
import '../util/store.dart';
import 'book.dart';
import 'reading_list.dart';

part 'feed_extensions.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList readingList;

  Feed(this.readingList) { loadState(); }

  /// state
  late Book _book;
  late int _chapter;
  late bool _isChapterRead;
  late DateTime? _dateLastSaved;

  /// calculated getters
  int get bookIndex => readingList.indexOf(book);
  int get chaptersRead => chapter + (isChapterRead ? 1 : 0) - 1;
  double get progress => readingList.progressTo(bookIndex, chaptersRead);

  /// methods
  void _nextBook() => _book = readingList[(bookIndex + 1) % readingList.count];
  void loadState() { _loadStateOrDefaults(); notifyListeners(); }

  void nextChapter() {
    assert(_isChapterRead);
    if (++_chapter > _book.chapterCount) { _nextBook(); _chapter = 1; }
    _isChapterRead = false;
    _saveState(); notifyListeners();
  }

  void setBookAndChapter(int bookIndex, int chapter) {
    _book = readingList[bookIndex];
    this.chapter = chapter;
    _isChapterRead = false;
    _saveState(); notifyListeners();
  }

  void toggleIsChapterRead() {
    _isChapterRead = !_isChapterRead;
    _saveState(); notifyListeners();
  }
}
