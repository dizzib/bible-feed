import 'package:bible_feed/model/base_iterable.dart';
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
class BibleReaders extends BaseIterable<BibleReader> {
  const BibleReaders(super._items);
}
