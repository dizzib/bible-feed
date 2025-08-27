import 'package:flutter/foundation.dart';

import '/service/verse_scope_service.dart';
import 'book.dart';
import 'reading_list.dart';

part 'feed_state.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList _readingList;
  final VerseScopeService _verseScopeService;

  Feed(this._readingList, this._verseScopeService, this._state);

  final FeedState _state;

  int get bookIndex => _readingList.indexOf(_state._book);
  int get chaptersRead => _state._chapter - (_state._isRead ? 0 : 1);
  double get progress => _readingList.progressTo(bookIndex, chaptersRead);
  ReadingList get readingList => _readingList;
  FeedState get state => _state;
  String get verseScopeName => _verseScopeService.verseScopeName(_state);

  void _notifyListeners() {
    _state._dateModified = DateTime.now();
    notifyListeners();
  }

  advance() {
    assert(_state._isRead);
    _state._verse = _verseScopeService.nextVerse(_state);
    if (_state._verse == 1 && ++_state._chapter > _state._book.chapterCount) {
      _state._book = _readingList[(bookIndex + 1) % _readingList.count];
      _state._chapter = 1;
    }
    _state._isRead = false;
    _notifyListeners();
  }

  setBookAndChapter(int bookIndex, int chapter) {
    if (bookIndex == this.bookIndex && chapter == _state._chapter) return;
    _state._book = readingList[bookIndex];
    _state._chapter = chapter;
    _state._verse = 1;
    _state._isRead = false;
    _notifyListeners();
  }

  toggleIsRead() {
    _state._isRead = !_state._isRead;
    _notifyListeners();
  }
}
