import 'package:bible_feed/model/chapter_splitter.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';

void main() {
  parameterizedTest(
    'getNextVerse, getLabel',
    [
      [1, 40, 'to\u00A0verse\u00A039'],
      [40, 70, 'verse\u00A040-69'],
      [70, 1, 'from\u00A0verse\u00A070'],
    ],
    (int verse, int expectNextVerse, String expectLabel) {
      expect(const ChapterSplitter('b0', 1, [40, 70]).getLabel(FeedState(book: b0, verse: verse)), expectLabel);
    },
  );
}
