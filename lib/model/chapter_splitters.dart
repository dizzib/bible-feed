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
        ChapterSplitter('luk', 1, [39]),
        ChapterSplitter('jhn', 6, [41]),
        ChapterSplitter('lev', 13, [29]),
        ChapterSplitter('num', 7, [48]),
        ChapterSplitter('deu', 28, [36]),
        ChapterSplitter('psa', 119, [17]),
        ChapterSplitter('1ki', 8, [33]),
        ChapterSplitter('neh', 7, [37]),
        ChapterSplitter('jer', 51, [33]),
        ChapterSplitter('act', 7, [30]),
      ]);

  ChapterSplitter? find(FeedState state) =>
      firstOrNullWhere((item) => item.bookKey == state.book.key && item.chapter == state.chapter);
}
