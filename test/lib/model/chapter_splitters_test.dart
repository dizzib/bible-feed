import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/chapter_splitter.dart';
import 'package:bible_feed/model/chapter_splitters.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';

void main() {
  final splitter1 = const ChapterSplitter('b0', 1, [1]);
  final splitter2 = const ChapterSplitter('b0', 2, [2]);
  final splitter3 = const ChapterSplitter('b1', 3, [3]);
  final splitter4 = const ChapterSplitter('b1', 4, [4]);

  final testee = ChapterSplitters([splitter1, splitter2, splitter3, splitter4]);

  parameterizedTest(
    'find',
    [
      [b0, 1, splitter1],
      [b0, 2, splitter2],
      [b0, 3, null],
      [b1, 2, null],
      [b1, 3, splitter3],
      [b1, 4, splitter4],
      [b1, 5, null],
      [b2, 1, null],
    ],
    (Book book, int chapter, ChapterSplitter? expectChapterSplitter) {
      expect(testee.find(FeedState(book: book, chapter: chapter)), expectChapterSplitter);
    },
  );
}
