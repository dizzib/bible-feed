import 'package:flutter/foundation.dart';
import 'book.dart';

extension ListExtension on List<Book> { int get totalChapters => fold(0, (t, b) => t + b.chapterCount); }

// books in a reading list (e.g. Matthew, Mark, Luke and John) without state
@immutable
final class ReadingList {
  final int count;  // e.g. 4 books in The Gospels
  final String key;  // e.g. gos
  final String name;  // e.g. Gospels
  final int totalChapters;
  final List<Book> _books;

  ReadingList(this.key, this.name, this._books) :
    totalChapters = _books.totalChapters,
    count = _books.length;

  /// properties
  Book operator [](int i) => _books[i];

  /// methods
  int chaptersTo(Book b, int chapter) => _books.sublist(0, indexOf(b)).totalChapters + chapter;
  Book getBook(String key) => _books.where((Book b) => b.key == key).single;
  int indexOf(Book b) => _books.indexOf(b);
  double progressTo(Book b, int chapter) => chaptersTo(b, chapter) / totalChapters;
}
