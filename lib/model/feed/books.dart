part of '../feed.dart';

// books in a reading list (e.g. Matthew, Mark, Luke and John) with state
class Books {
  final String key;  // e.g. gos
  final String name;  // e.g. Gospels
  final List<Book> _bookList;
  final int _totalChapters;

  Books(
    this.key,
    this.name,
    this._bookList
  ) : _totalChapters = _bookList.fold(0, (t, b) => t + b.count);

  // state
  int _index = 0;

  // testing
  @visibleForTesting set current(Book b) => _index = indexOf(b);
  @visibleForTesting getBook(String key) => _bookList.where((Book b) => b.key == key).single;
  @visibleForTesting nextBook() { _index = ++_index % count; }

  // public
  operator [](int i) => _bookList[i];
  chaptersTo(Book b, int chapter) => _bookList.sublist(0, indexOf(b)).fold(0, (t, b) => t + b.count) + chapter;
  int get count => _bookList.length;  // e.g. 4 books in The Gospels
  Book get current => _bookList[_index];
  indexOf(Book b) => _bookList.indexOf(b);
  get progress => progressTo(current, current.chaptersRead);
  progressTo(Book b, int chapter) => chaptersTo(b, chapter) / _totalChapters;
  get totalChapters => _totalChapters;
}
