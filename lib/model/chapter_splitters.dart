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

  static const psalm119VerseList = [17, 33, 49, 65, 81, 97, 113, 129, 145, 161]; // used by unit test

  ChapterSplitter? find(FeedState state) =>
      firstOrNullWhere((item) => item.bookKey == state.bookKey && item.chapter == state.chapter);
}

@module
abstract class ChapterSplittersModule {
  @lazySingleton
  List<ChapterSplitter> get chapterSplitters => [
    const ChapterSplitter('1cr', 6, [44]),
    const ChapterSplitter('1ki', 8, [37]),
    const ChapterSplitter('act', 7, [30]),
    const ChapterSplitter('deu', 28, [36]),
    const ChapterSplitter('eze', 16, [35]),
    const ChapterSplitter('gen', 24, [33]),
    const ChapterSplitter('jer', 48, [26]),
    const ChapterSplitter('jer', 49, [20]),
    const ChapterSplitter('jer', 50, [23]),
    const ChapterSplitter('jer', 51, [33]),
    const ChapterSplitter('jhn', 6, [34]),
    const ChapterSplitter('jos', 15, [33]),
    const ChapterSplitter('lam', 3, [33]),
    const ChapterSplitter('lev', 13, [29]),
    const ChapterSplitter('luk', 1, [39]),
    const ChapterSplitter('luk', 9, [28]),
    const ChapterSplitter('luk', 12, [32]),
    const ChapterSplitter('mat', 26, [36]),
    const ChapterSplitter('mat', 27, [35]),
    const ChapterSplitter('neh', 7, [37]),
    const ChapterSplitter('num', 7, [48]),
    const ChapterSplitter('num', 26, [35]),
    const ChapterSplitter('psa', 78, [36]),
    const ChapterSplitter('psa', 119, ChapterSplitters.psalm119VerseList),
  ];
}
