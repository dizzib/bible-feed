import 'package:flutter/foundation.dart';

import 'base_list.dart';
import 'book.dart';

// books in a reading list (e.g. Matthew, Mark, Luke and John) without state
@immutable
final class ReadingList extends BaseList<Book> {
  ReadingList(this.key, this.name, super._items) : count = _items.length, totalChapters = _items.totalChapters;

  final int count; // e.g. 4 books in The Gospels
  final String key; // e.g. gos
  final String name; // e.g. Gospels
  final int totalChapters;

  /// methods
  int chaptersTo(int bookIndex, int chapter) => sublistTo(bookIndex).totalChapters + chapter;
  Book getBook(String key) => where((Book b) => b.key == key).single;
  double progressTo(int bookIndex, int chapter) => chaptersTo(bookIndex, chapter) / totalChapters;
}

extension ListExtension on List<Book> {
  int get totalChapters => fold(0, (t, b) => t + b.chapterCount);
}
