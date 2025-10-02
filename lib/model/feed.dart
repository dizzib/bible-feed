import 'package:flutter/foundation.dart';

import 'book.dart';
import 'reading_list.dart';

part 'feed_state.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  final ReadingList _readingList;
  final FeedState _state;

  Feed(this._readingList, this._state);

  int get bookIndex => _readingList.indexOf(_state._book);
  int get chaptersRead => _state._chapter - (_state._isRead ? 0 : 1);
  double get progress => _readingList.progressTo(bookIndex, chaptersRead);
  ReadingList get readingList => _readingList;
  FeedState get state => _state;

  void setBookChapterVerse(int bookIndex, int chapter, [int verse = 1]) {
    if (bookIndex == this.bookIndex && chapter == _state._chapter && verse == _state.verse) return;
    _state._book = readingList[bookIndex];
    _state._chapter = chapter;
    _state._verse = verse;
    _state._isRead = false;
    _state._dateModified = DateTime.now();
    notifyListeners();
  }

  void toggleIsRead() {
    _state._isRead = !_state._isRead;
    _state._dateModified = DateTime.now();
    notifyListeners();
  }
}
