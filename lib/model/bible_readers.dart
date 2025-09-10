import 'package:flutter/foundation.dart';

import 'bible_reader.dart';

// mockito cannot mock enums, otherwise we could use an enhanced enum
enum BibleReaderKeys {
  none,
  andBibleApp,
  blueLetterApp,
  blueLetterWeb,
  lifeBibleApp,
  logosBibleApp,
  oliveTreeApp,
  youVersionApp,
  weDevoteApp,
}

// base class, for unit tests
@immutable
class BibleReaders extends Iterable<BibleReader> {
  const BibleReaders(this._items);

  final List<BibleReader> _items;

  @override
  Iterator<BibleReader> get iterator => _items.iterator;

  BibleReader operator [](int i) => _items[i];
}
