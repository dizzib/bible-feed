import 'package:flutter/foundation.dart';

part '/extension/book.dart';

// an individual book e.g. Matthew
@immutable
final class Book {
  const Book(this.key, this.name, this.chapterCount);

  final String key; // e.g. mar
  final String name; // e.g. Mark
  final int chapterCount;
}
