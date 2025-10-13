import 'package:bible_feed/model/chapter_splitter.dart';
import 'package:bible_feed/model/chapter_splitters.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/manager/chapter_split_service.dart';
import 'package:bible_feed/manager/chapter_split_toggler_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'chapter_split_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ChapterSplitter>(), MockSpec<ChapterSplitters>(), MockSpec<ChapterSplitTogglerService>()])
void main() {
  final mockChapterSplitter = MockChapterSplitter();
  final mockChapterSplitters = MockChapterSplitters();
  final mockTogglerService = MockChapterSplitTogglerService();
  final state = FeedState(book: b0);
  late ChapterSplitService testee;

  setUp(() {
    when(mockTogglerService.isEnabled).thenReturn(true);
    testee = ChapterSplitService(mockChapterSplitters, mockTogglerService);
  });

  group('getNextVerse', () {
    test('disabled, should return 1 and empty string', () {
      when(mockTogglerService.isEnabled).thenReturn(false);
      expect(testee.getNextVerse(state), 1);
      expect(testee.getLabel(state), '');
    });

    test('no splitter, should return 1 and empty string', () {
      when(mockChapterSplitters.find(state)).thenReturn(null);
      expect(testee.getNextVerse(state), 1);
      expect(testee.getLabel(state), '');
    });

    test('enabled splitter, should return next verse and label from splitter', () {
      when(mockChapterSplitter.getNextVerse(state)).thenReturn(2);
      when(mockChapterSplitter.getLabel(state)).thenReturn('label');
      when(mockChapterSplitters.find(state)).thenReturn(mockChapterSplitter);
      expect(testee.getNextVerse(state), 2);
      expect(testee.getLabel(state), 'label');
    });
  });
}
