import 'package:flutter/foundation.dart';
import '../data/store.dart';

part 'feed/book.dart';
part 'feed/books.dart';

class _StoreKeys {
  _StoreKeys(String booksKey) :
    book = '$booksKey.book',
    chapter = '$booksKey.chapter',
    dateLastSaved = '$booksKey.dateLastSaved',
    isChapterRead = '$booksKey.isChapterRead';
  final String book;
  final String chapter;
  final String isChapterRead;
  final String dateLastSaved;
}

// Feed manipulates, dispenses and stores a reading list (Books)
class Feed with ChangeNotifier {
  Feed(this.books) : _storeKeys = _StoreKeys(books._key) {
    _loadState();
    notifyListeners();
  }

  /// private

  final _StoreKeys _storeKeys;

  void _loadState() {
    String? bookKey = Store.getString(_storeKeys.book);
    if (bookKey == null) return;
    books.current = books.getBook(bookKey);

    int? chapter = Store.getInt(_storeKeys.chapter);
    if (chapter == null) return;
    books.current.chapter = chapter;

    bool? isChapterRead = Store.getBool(_storeKeys.isChapterRead);
    if (isChapterRead == null) return;
    books.current.isChapterRead = isChapterRead;

    String? dateIso8601 = Store.getString(_storeKeys.dateLastSaved);
    if (dateIso8601 == null) return;
    dateLastSaved = DateTime.parse(dateIso8601);
  }

  void _saveState() {
    dateLastSaved = DateTime.now();
    Store.setString(_storeKeys.book, books.current.key);
    Store.setInt(_storeKeys.chapter, books.current.chapter);
    Store.setBool(_storeKeys.isChapterRead, books.current.isChapterRead);
    Store.setString(_storeKeys.dateLastSaved, dateLastSaved.toIso8601String());
  }

  /// public

  final Books books;
  DateTime dateLastSaved = DateTime(0);  // making this non-nullable simplifies things in feeds.dart

  void nextChapter() {
    var b = books.current;
    b.nextChapter();
    if (b.chapter == 1) { books.nextBook(); }
    notifyListeners();
    _saveState();
  }

  void setBookAndChapter(Book book, int chapter) {
    books.current._reset();
    books.current = book;
    books.current.chapter = chapter;
    notifyListeners();
    _saveState();
  }

  void toggleIsChapterRead() {
    books.current.isChapterRead = !books.current.isChapterRead;
    notifyListeners();
    _saveState();
  }
}
