import 'package:flutter/foundation.dart';
import '../data/store.dart';
import 'book.dart';
import 'reading_list.dart';

class _StoreKeys {
  final String bookKey;
  final String chapter;
  final String isChapterRead;
  final String dateLastSaved;

  const _StoreKeys(readingListKey) :
    bookKey = '$readingListKey.book',
    chapter = '$readingListKey.chapter',
    dateLastSaved = '$readingListKey.dateLastSaved',
    isChapterRead = '$readingListKey.isChapterRead';
}

// Feed manipulates, dispenses and stores a reading-list
class Feed with ChangeNotifier {
  final ReadingList readingList;
  final _StoreKeys _storeKeys;

  Feed(this.readingList) : _storeKeys = _StoreKeys(readingList.key) { _loadStateAndNotifyListeners(); }

  void _loadStateAndNotifyListeners() {
    var bookKey = Store.getString(_storeKeys.bookKey);
    if (bookKey == null) return;  // on first run, this will be null
    readingList.current = readingList.getBook(bookKey);
    readingList.current.chapter = Store.getInt(_storeKeys.chapter)!;
    readingList.current.isChapterRead = Store.getBool(_storeKeys.isChapterRead)!;
    dateLastSaved = DateTime.parse(Store.getString(_storeKeys.dateLastSaved)!);
    notifyListeners();
  }

  void _saveStateAndNotifyListeners() {
    dateLastSaved = DateTime.now();
    Store.setString(_storeKeys.bookKey, readingList.current.key);
    Store.setInt(_storeKeys.chapter, readingList.current.chapter);
    Store.setBool(_storeKeys.isChapterRead, readingList.current.isChapterRead);
    Store.setString(_storeKeys.dateLastSaved, dateLastSaved.toIso8601String());
    notifyListeners();
  }

  // state
  DateTime dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  void nextChapter() {
    var b = readingList.current;
    b.nextChapter();
    if (b.chapter == 1) readingList.nextBook();
    _saveStateAndNotifyListeners();
  }

  void setBookAndChapter(Book book, int chapter) {
    readingList.current.reset();
    readingList.current = book;
    readingList.current.chapter = chapter;
    _saveStateAndNotifyListeners();
  }

  void toggleIsChapterRead() {
    readingList.current.isChapterRead = !readingList.current.isChapterRead;
    _saveStateAndNotifyListeners();
  }
}
