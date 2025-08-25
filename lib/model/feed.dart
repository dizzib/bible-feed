import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/service/verse_scope_service.dart';
import 'book.dart';
import 'reading_list.dart';

part '/extension/feed_persister.dart';
part 'feed_state.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList _readingList;
  final SharedPreferences _sharedPreferences;
  final VerseScopeService _verseScopeService;
  final FeedState _feedState;

  Feed(this._readingList, this._sharedPreferences, this._verseScopeService, this._feedState) {
    loadStateOrDefaults();
  }

  late bool _isRead;
  late int _verse;

  @visibleForTesting
  set isRead(bool value) => _isRead = value;

  int get bookIndex => _readingList.indexOf(_feedState._book);
  int get chaptersRead => _feedState._chapter + (_isRead ? 1 : 0) - 1;
  bool get isRead => _isRead;
  double get progress => _readingList.progressTo(bookIndex, chaptersRead);
  ReadingList get readingList => _readingList;
  FeedState get state => _feedState;
  int get verse => _verse;
  String get verseScopeName => _verseScopeService.verseScopeName(this);

  Future _notifyListenersAndSave() async {
    _feedState._dateModified = DateTime.now();
    notifyListeners();
    await _saveState();
  }

  Future advance() async {
    assert(_isRead);
    _verse = _verseScopeService.nextVerse(this);
    if (_verse == 1 && ++_feedState._chapter > _feedState._book.chapterCount) {
      _feedState._book = _readingList[(bookIndex + 1) % _readingList.count];
      _feedState._chapter = 1;
    }
    _isRead = false;
    await _notifyListenersAndSave();
  }

  Future setBookAndChapter(int bookIndex, int chapter) async {
    if (bookIndex == this.bookIndex && chapter == _feedState._chapter) return;
    _feedState._book = readingList[bookIndex];
    _feedState._chapter = chapter;
    _verse = 1;
    _isRead = false;
    await _notifyListenersAndSave();
  }

  Future toggleIsRead() async {
    _isRead = !_isRead;
    await _notifyListenersAndSave();
  }
}
