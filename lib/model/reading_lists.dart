import 'package:flutter/foundation.dart';

import 'base_iterable.dart';
import 'reading_list.dart';

// base class, for unit tests
@immutable
class ReadingLists extends BaseIterable<ReadingList> {
  const ReadingLists(super._items);
}
