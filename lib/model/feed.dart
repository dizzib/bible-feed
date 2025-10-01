import 'package:flutter/foundation.dart';

import '/service/chapter_split_service.dart';
import '/service/date_time_service.dart';
import 'book.dart';
import 'reading_list.dart';

part 'feed_state.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList _readingList;
  final ChapterSplitService _chapterSplitService;
  final DateTimeService _dateTimeService;

  Feed(this._readingList, this._chapterSplitService, this._dateTimeService, this._state);

  final FeedState _state;

  int get bookIndex => _readingList.indexOf(_state._book);
  int get chaptersRead => _state._chapter - (_state._isRead ? 0 : 1);
  String get chapterSplitLabel => _chapterSplitService.getLabel(_state);
  double get progress => _readingList.progressTo(bookIndex, chaptersRead);
  ReadingList get readingList => _readingList;
  FeedState get state => _state;

  void _setDateModifiedThenNotify() {
    _state._dateModified = _dateTimeService.now;
    notifyListeners();
  }

  void advance() {
    assert(_state._isRead);
    _state._verse = _chapterSplitService.getNextVerse(_state);
    if (_state._verse == 1 && ++_state._chapter > _state._book.chapterCount) {
      _state._book = _readingList[(bookIndex + 1) % _readingList.length];
      _state._chapter = 1;
    }
    _state._isRead = false;
    _setDateModifiedThenNotify();
  }

  void setBookAndChapter(int bookIndex, int chapter) {
    if (bookIndex == this.bookIndex && chapter == _state._chapter) return;
    _state._book = readingList[bookIndex];
    _state._chapter = chapter;
    _state._verse = 1;
    _state._isRead = false;
    _setDateModifiedThenNotify();
  }

  void toggleIsRead() {
    _state._isRead = !_state._isRead;
    _setDateModifiedThenNotify();
  }
}
