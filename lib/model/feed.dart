import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'book.dart';
import 'reading_list.dart';

part '/extension/feed.dart';
part '/extension/feed_tip.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  Feed(this._readingList) {
    loadStateOrDefaults();
    notifyListeners();
  }

  late Book _book;
  late int _chapter;
  late DateTime? _dateModified;
  late bool _isChapterRead;
  final ReadingList _readingList;

  Book get book => _book;
  int get bookIndex => _readingList.indexOf(_book);
  int get chapter => _chapter;
  int get chaptersRead => _chapter + (_isChapterRead ? 1 : 0) - 1;
  DateTime? get dateModified => _dateModified;
  bool get isChapterRead => _isChapterRead;
  double get progress => _readingList.progressTo(bookIndex, chaptersRead);
  ReadingList get readingList => _readingList;

  @visibleForTesting
  set isChapterRead(bool value) => _isChapterRead = value;

  Future _notifyListenersAndSave() async {
    notifyListeners();
    await _saveState();
  }

  Future nextChapter() async {
    assert(_isChapterRead);
    void nextBook() => _book = readingList[(bookIndex + 1) % readingList.count];
    if (++_chapter > _book.chapterCount) {
      nextBook();
      _chapter = 1;
    }
    _isChapterRead = false;
    await _notifyListenersAndSave();
  }

  Future setBookAndChapter(int bookIndex, int chapter) async {
    if (bookIndex == this.bookIndex && chapter == this.chapter) return;
    _book = readingList[bookIndex];
    _chapter = chapter;
    _isChapterRead = false;
    await _notifyListenersAndSave();
  }

  Future toggleIsChapterRead() async {
    _isChapterRead = !_isChapterRead;
    await _notifyListenersAndSave();
  }
}
