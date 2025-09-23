import 'package:bible_feed/model/chapter_splitter.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';

void main() {
  parameterizedTest(
    'psalm 119 should operate on groups of 16 verses',
    [
      [1, 17, 'to\u00A0verse\u00A016'],
      [65, 81, 'verse\u00A065-80'],
      [161, 1, 'from\u00A0verse\u00A0161'],
    ],
    (int verse, int expectNextVerse, String expectLabel) {
      final testee = ChapterSplitter('b0', 1, List.generate(10, (i) => 17 + i * 16));
      expect(testee.getLabel(FeedState(book: b0, verse: verse)), expectLabel);
    },
  );
}
