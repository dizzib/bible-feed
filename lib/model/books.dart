import 'book.dart';

extension BookListHelper on List<Book> { int get totalChapters => fold(0, (t, b) => t + b.chapterCount); }

// books in a reading list (e.g. Matthew, Mark, Luke and John) with state
class Books {
  final int count;  // e.g. 4 books in The Gospels
  final String key;  // e.g. gos
  final String name;  // e.g. Gospels
  final int totalChapters;
  final List<Book> _bookList;

  Books(this.key, this.name, this._bookList) :
    totalChapters = _bookList.totalChapters,
    count = _bookList.length;

  // state
  int _index = 0;

  /// properties
  Book operator [](int i) => _bookList[i];
  Book get current => _bookList[_index];
  set current(Book b) => _index = indexOf(b);
  double get progress => progressTo(current, current.chaptersRead);

  /// methods
  int chaptersTo(Book b, int chapter) => _bookList.sublist(0, indexOf(b)).totalChapters + chapter;
  Book getBook(String key) => _bookList.where((Book b) => b.key == key).single;
  int indexOf(Book b) => _bookList.indexOf(b);
  void nextBook() { _index = ++_index % count; }
  double progressTo(Book b, int chapter) => chaptersTo(b, chapter) / totalChapters;
}
