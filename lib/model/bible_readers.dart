import 'package:flutter/foundation.dart';

import 'base_iterable.dart';
import 'bible_reader.dart';

// base class, for unit tests
@immutable
class BibleReaders extends BaseIterable<BibleReader> {
  const BibleReaders(super._items);
}
