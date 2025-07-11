import 'package:flutter/foundation.dart';

// an individual book e.g. Matthew
@immutable
final class Book {
  final String key; // e.g. mar
  final String name; // e.g. Mark
  final int chapterCount;
  final String? osisParatextAbbrev; // e.g. mrk, if different from key. For deeplinking to bible apps.

  const Book(this.key, this.name, this.chapterCount, [this.osisParatextAbbrev]);
}
