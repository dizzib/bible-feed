import 'package:bible_feed/model/base_iterable.dart';
import 'package:flutter/foundation.dart';

import 'bible_reader.dart';

// base class, for unit tests
@immutable
class BibleReaders extends BaseIterable<BibleReader> {
  const BibleReaders(super._items);
}
