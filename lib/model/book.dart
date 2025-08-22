import 'package:flutter/foundation.dart';

// an individual book e.g. Matthew
@immutable
final class Book {
  const Book(this.key, this.name, this.chapterCount, [this.verseScopeMaps]);

  final String key; // e.g. mar
  final String name; // e.g. Mark
  final int chapterCount;
  final Map<int, Map<int, String>>? verseScopeMaps;
}
