import 'package:flutter/foundation.dart';

import 'base_list.dart';
import 'bible_reader.dart';

// base class, for unit tests
@immutable
class BibleReaders extends BaseList<BibleReader> {
  const BibleReaders(super._items);
}
