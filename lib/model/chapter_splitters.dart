import 'package:dartx/dartx.dart';

import 'base_list.dart';
import 'chapter_splitter.dart';
import 'feed.dart';

// use base class for unit tests, extend for production
class ChapterSplitters extends BaseList<ChapterSplitter> {
  ChapterSplitters(super._items);

  ChapterSplitter? find(FeedState state) =>
      firstOrNullWhere((item) => item.bookKey == state.book.key && item.chapter == state.chapter);
}
