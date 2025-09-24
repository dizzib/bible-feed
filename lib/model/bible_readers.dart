import 'package:flutter/foundation.dart';

import 'base_list.dart';
import 'bible_reader.dart';

// use base class for unit tests, extend for production
@immutable
class BibleReaders extends BaseList<BibleReader> {
  const BibleReaders(super._items);
}
