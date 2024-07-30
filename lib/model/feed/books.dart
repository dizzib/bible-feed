part of '../feed.dart';

// books in a reading list (e.g. Matthew, Mark, Luke and John) with state
class Books {
  Books(
    this._key,
    this._name,
    this._bookList
  ) : _totalChapters = _bookList.fold(0, (t, b) => t + b.count);

  // private
  final List<Book> _bookList;
  int _index = 0;
  final String _key;  // e.g. gos
  final String _name;  // e.g. Gospels
  final int _totalChapters;

  // testing
  @visibleForTesting set current(Book b) => _index = indexOf(b);
  @visibleForTesting Book getBook(String key) => _bookList.where((Book b) => b.key == key).single;
  @visibleForTesting void nextBook() { _index = ++_index % count; }

  // public
  Book operator [](int i) => _bookList[i];
  int chaptersTo(Book b, int chapter) => _bookList.sublist(0, indexOf(b)).fold(0, (t, b) => t + b.count) + chapter;
  int get count => _bookList.length;  // e.g. 4 books in The Gospels
  Book get current => _bookList[_index];
  int indexOf(Book b) => _bookList.indexOf(b);
  String get name => _name;
  double get progress => progressTo(current, current.chaptersRead);
  double progressTo(Book b, int chapter) => chaptersTo(b, chapter) / _totalChapters;
  int get totalChapters => _totalChapters;
}
