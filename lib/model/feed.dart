import 'package:flutter/foundation.dart';

import '/service/verse_scope_service.dart';
import 'book.dart';
import 'reading_list.dart';

part '/extension/feed_persister.dart';
part 'feed_state.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList _readingList;
  final VerseScopeService _verseScopeService;
  final FeedState _feedState;

  Feed(this._readingList, this._verseScopeService, this._feedState) {
    loadStateOrDefaults();
  }

  @visibleForTesting
  set isRead(bool value) => _feedState._isRead = value;

  int get bookIndex => _readingList.indexOf(_feedState._book);
  int get chaptersRead => _feedState._chapter + (_feedState._isRead ? 1 : 0) - 1;
  double get progress => _readingList.progressTo(bookIndex, chaptersRead);
  ReadingList get readingList => _readingList;
  FeedState get state => _feedState;
  String get verseScopeName => _verseScopeService.verseScopeName(this);

  void _notifyListenersAndSave() {
    _feedState._dateModified = DateTime.now();
    notifyListeners();
  }

  Future advance() async {
    assert(_feedState._isRead);
    _feedState._verse = _verseScopeService.nextVerse(this);
    if (_feedState._verse == 1 && ++_feedState._chapter > _feedState._book.chapterCount) {
      _feedState._book = _readingList[(bookIndex + 1) % _readingList.count];
      _feedState._chapter = 1;
    }
    _feedState._isRead = false;
    _notifyListenersAndSave();
  }

  Future setBookAndChapter(int bookIndex, int chapter) async {
    if (bookIndex == this.bookIndex && chapter == _feedState._chapter) return;
    _feedState._book = readingList[bookIndex];
    _feedState._chapter = chapter;
    _feedState._verse = 1;
    _feedState._isRead = false;
    _notifyListenersAndSave();
  }

  Future toggleIsRead() async {
    _feedState._isRead = !_feedState._isRead;
    _notifyListenersAndSave();
  }
}
