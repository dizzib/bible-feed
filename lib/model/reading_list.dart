import 'package:flutter/foundation.dart';
import 'book.dart';

// books in a reading list (e.g. Matthew, Mark, Luke and John) without state
@immutable
final class ReadingList {
  ReadingList(this.key, this.name, this._books)
      : count = _books.length,
        totalChapters = _books.totalChapters;

  final int count; // e.g. 4 books in The Gospels
  final String key; // e.g. gos
  final String name; // e.g. Gospels
  final int totalChapters;
  final List<Book> _books;

  /// properties
  Book operator [](int i) => _books[i];

  /// methods
  int chaptersTo(int bookIndex, int chapter) => _books.sublist(0, bookIndex).totalChapters + chapter;
  Book getBook(String key) => _books.where((Book b) => b.key == key).single;
  int indexOf(Book b) => _books.indexOf(b);
  double progressTo(int bookIndex, int chapter) => chaptersTo(bookIndex, chapter) / totalChapters;
}

extension ListExtension on List<Book> {
  int get totalChapters => fold(0, (t, b) => t + b.chapterCount);
}
