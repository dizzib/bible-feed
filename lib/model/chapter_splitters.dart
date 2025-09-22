import 'package:injectable/injectable.dart';
import 'package:dartx/dartx.dart';

import 'base_list.dart';
import 'chapter_splitter.dart';
import 'feed.dart';

@lazySingleton
class ChapterSplitters extends BaseList<ChapterSplitter> {
  ChapterSplitters()
    : super(const [
        ChapterSplitter('mat', 26, [36]),
      ]);

  ChapterSplitter? find(FeedState state) =>
      firstOrNullWhere((item) => item.bookKey == state.book.key && item.chapter == state.chapter);
}
