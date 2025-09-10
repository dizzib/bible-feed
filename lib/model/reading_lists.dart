import 'package:flutter/foundation.dart';

import 'base_list.dart';
import 'reading_list.dart';

// base class, for unit tests
@immutable
class ReadingLists extends BaseList<ReadingList> {
  const ReadingLists(super._items);
}
