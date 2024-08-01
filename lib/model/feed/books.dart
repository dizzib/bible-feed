part of '../feed.dart';

// books in a reading list (e.g. Matthew, Mark, Luke and John) with state
class Books {
  final String key;  // e.g. gos
  final String name;  // e.g. Gospels
  final List<Book> _bookList;
  final int count;  // e.g. 4 books in The Gospels
  final int totalChapters;

  Books(this.key, this.name, this._bookList) :
    totalChapters = _bookList.fold(0, (t, b) => t + b.chapterCount),
    count = _bookList.length;

  // state
  int _index = 0;

  // testing
  @visibleForTesting set current(Book b) => _index = indexOf(b);
  @visibleForTesting getBook(String key) => _bookList.where((Book b) => b.key == key).single;
  @visibleForTesting nextBook() { _index = ++_index % count; }

  // public
  Book operator [](int i) => _bookList[i];
  Book get current => _bookList[_index];
  get progress => progressTo(current, current.chaptersRead);
  indexOf(Book b) => _bookList.indexOf(b);
  chaptersTo(Book b, int chapter) => _bookList.sublist(0, indexOf(b)).fold(0, (t, b) => t + b.chapterCount) + chapter;
  progressTo(Book b, int chapter) => chaptersTo(b, chapter) / totalChapters;
}
