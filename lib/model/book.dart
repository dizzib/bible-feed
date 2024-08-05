import 'package:flutter/foundation.dart';

// an individual book e.g. Matthew
@immutable
final class Book {
  final String key;  // e.g. mat
  final String name;  // e.g. Matthew
  final int chapterCount;

  const Book(this.key, this.name, this.chapterCount);
}
