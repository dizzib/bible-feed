import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_list.dart';
import 'chapter_splitter.dart';
import 'feed.dart';

@immutable
@lazySingleton
class ChapterSplitters extends BaseList<ChapterSplitter> {
  const ChapterSplitters(super._items);

  ChapterSplitter? find(FeedState state) =>
      firstOrNullWhere((item) => item.bookKey == state.book.key && item.chapter == state.chapter);
}

@module
abstract class ChapterSplittersModule {
  @lazySingleton
  List<ChapterSplitter> get chapterSplitters => [
    const ChapterSplitter('1ki', 8, [33]),
    const ChapterSplitter('act', 7, [30]),
    const ChapterSplitter('deu', 28, [36]),
    const ChapterSplitter('jer', 51, [33]),
    const ChapterSplitter('jhn', 6, [41]),
    const ChapterSplitter('lev', 13, [29]),
    const ChapterSplitter('luk', 1, [39]),
    const ChapterSplitter('mat', 26, [36]),
    const ChapterSplitter('neh', 7, [37]),
    const ChapterSplitter('num', 7, [48]),
    ChapterSplitter('psa', 119, List.generate(10, (i) => 17 + i * 16)),
  ];
}
