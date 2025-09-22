import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/verse_scope.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_data.dart';

void main() {
  late VerseScope testee;

  setUp(() {
    testee = const VerseScope('b0', 1, [40, 70]);
  });

  group('getNextVerse', () {
    test('if at verse 1, should return next verse', () {
      expect(testee.getNextVerse(FeedState(book: b0)), 40);
    });

    test('if in midst of scope, should return next verse', () {
      expect(testee.getNextVerse(FeedState(book: b0, verse: 40)), 70);
    });

    test('if at last verse, should return 1', () {
      expect(testee.getNextVerse(FeedState(book: b0, verse: 70)), 1);
    });
  });

  group('getLabel', () {
    test('if at verse 1, should return "to verse x"', () {
      expect(testee.getLabel(FeedState(book: b0)), 'to\u00A0verse\u00A039');
    });

    test('if in midst of scope, should return "verse from-to" range', () {
      expect(testee.getLabel(FeedState(book: b0, verse: 40)), 'verse\u00A040-69');
    });

    test('if at last verse, should return "from verse x"', () {
      expect(testee.getLabel(FeedState(book: b0, verse: 70)), 'from\u00A0verse\u00A070');
    });
  });
}
