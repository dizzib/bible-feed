import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';

part 'book.mapper.dart';

// an individual book e.g. Matthew
@MappableClass()
@immutable
final class Book with BookMappable {
  const Book(this.key, this.name, this.chapterCount);

  final String key; // e.g. mar
  final String name; // e.g. Mark
  final int chapterCount;
}
