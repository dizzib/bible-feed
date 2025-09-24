import 'package:flutter/foundation.dart';

import 'base_list.dart';
import 'reading_list.dart';

// use base class for unit tests, extend for production
@immutable
class ReadingLists extends BaseList<ReadingList> {
  const ReadingLists(super._items);
}
