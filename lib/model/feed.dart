import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/service/verse_scope_service.dart';
import 'book.dart';
import 'reading_list.dart';

part '/extension/feed_persister.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList _readingList;
  final SharedPreferences _sharedPreferences;
  final VerseScopeService _verseScopeService;

  Feed(this._readingList, this._sharedPreferences, this._verseScopeService) {
    loadStateOrDefaults();
  }

  late Book _book;
  late int _chapter;
  late DateTime? _dateModified;
  late bool _isRead;
  late int _verse;

  @visibleForTesting
  set isRead(bool value) => _isRead = value;

  Book get book => _book;
  int get bookIndex => _readingList.indexOf(_book);
  int get chapter => _chapter;
  int get chaptersRead => _chapter + (_isRead ? 1 : 0) - 1;
  DateTime? get dateModified => _dateModified;
  bool get isRead => _isRead;
  double get progress => _readingList.progressTo(bookIndex, chaptersRead);
  ReadingList get readingList => _readingList;
  int get verse => _verse;
  String get verseScopeName => _verseScopeService.verseScopeName(this);

  void _advanceChapterOrBook() {
    if (++_chapter > _book.chapterCount) {
      _book = _readingList[(bookIndex + 1) % _readingList.count];
      _chapter = 1;
    }
  }

  Future _notifyListenersAndSave() async {
    notifyListeners();
    await _saveState();
  }

  Future advance() async {
    assert(_isRead);
    _verse = _verseScopeService.nextVerse(this);
    if (_verse == 1) _advanceChapterOrBook();
    _isRead = false;
    await _notifyListenersAndSave();
  }

  Future setBookAndChapter(int bookIndex, int chapter) async {
    if (bookIndex == this.bookIndex && chapter == this.chapter) return;
    _book = readingList[bookIndex];
    _chapter = chapter;
    _isRead = false;
    await _notifyListenersAndSave();
  }

  Future toggleIsRead() async {
    _isRead = !_isRead;
    await _notifyListenersAndSave();
  }
}
