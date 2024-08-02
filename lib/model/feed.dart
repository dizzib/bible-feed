import 'package:flutter/foundation.dart';
import '../data/store.dart';
import 'book.dart';
import 'books.dart';

class _StoreKeys {
  final String bookKey;
  final String chapter;
  final String isChapterRead;
  final String dateLastSaved;

  const _StoreKeys(booksKey) :
    bookKey = '$booksKey.book',
    chapter = '$booksKey.chapter',
    dateLastSaved = '$booksKey.dateLastSaved',
    isChapterRead = '$booksKey.isChapterRead';
}

// Feed manipulates, dispenses and stores a reading list (Books)
class Feed with ChangeNotifier {
  final Books books;
  final _StoreKeys _storeKeys;

  Feed(this.books) : _storeKeys = _StoreKeys(books.key) { _loadStateAndNotifyListeners(); }

  void _loadStateAndNotifyListeners() {
    var bookKey = Store.getString(_storeKeys.bookKey);
    if (bookKey == null) return;  // on first run, this will be null
    books.current = books.getBook(bookKey);
    books.current.chapter = Store.getInt(_storeKeys.chapter)!;
    books.current.isChapterRead = Store.getBool(_storeKeys.isChapterRead)!;
    dateLastSaved = DateTime.parse(Store.getString(_storeKeys.dateLastSaved)!);
    notifyListeners();
  }

  void _saveStateAndNotifyListeners() {
    dateLastSaved = DateTime.now();
    Store.setString(_storeKeys.bookKey, books.current.key);
    Store.setInt(_storeKeys.chapter, books.current.chapter);
    Store.setBool(_storeKeys.isChapterRead, books.current.isChapterRead);
    Store.setString(_storeKeys.dateLastSaved, dateLastSaved.toIso8601String());
    notifyListeners();
  }

  // state
  DateTime dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  void nextChapter() {
    var b = books.current;
    b.nextChapter();
    if (b.chapter == 1) books.nextBook();
    _saveStateAndNotifyListeners();
  }

  void setBookAndChapter(Book book, int chapter) {
    books.current.reset();
    books.current = book;
    books.current.chapter = chapter;
    _saveStateAndNotifyListeners();
  }

  void toggleIsChapterRead() {
    books.current.isChapterRead = !books.current.isChapterRead;
    _saveStateAndNotifyListeners();
  }
}
