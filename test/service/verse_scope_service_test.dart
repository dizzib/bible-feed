import 'package:bible_feed/model/feed.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/verse_scopes.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:bible_feed/service/verse_scope_toggler_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test_data.dart';

class MockVerseScopes extends Mock implements VerseScopes {}

class MockVerseScopeTogglerService extends Mock implements VerseScopeTogglerService {}

void main() {
  late MockVerseScopes mockVerseScopes;
  late MockVerseScopeTogglerService mockTogglerService;
  late FeedState state;
  late VerseScopeService testee;

  setUp(() {
    mockVerseScopes = MockVerseScopes();
    mockTogglerService = MockVerseScopeTogglerService();
    when(() => mockVerseScopes['b1']).thenReturn({
      1: {1: 'ℵ_Aleph', 2: 'ℶ_Beth'},
      2: 3,
    });
    when(() => mockTogglerService.isEnabled).thenReturn(true);
    testee = VerseScopeService(mockVerseScopes, mockTogglerService);
    state = FeedState(book: const Book('b1', 'Book 2', 3), chapter: 1, isRead: false);
  });

  FeedState copyStateWith({Book? book, int? chapter, int? verse}) => FeedState(
      book: book ?? state.book, chapter: chapter ?? state.chapter, isRead: state.isRead, verse: verse ?? state.verse);

  parameterizedTest(
    'getNextVerse',
    [
      [false, 1, 1, 1, 'service disabled'],
      [true, 1, 1, 2, 'not at last verse in scope'],
      [true, 1, 2, 1, 'at last verse in scope'],
      [true, 3, 1, 1, 'scope not applicable to chapter'],
    ],
    customDescriptionBuilder: (_, __, values) => 'when ${values[4]} should return ${values[3]}',
    (bool isEnabled, int chapter, int verse, int expectValue, [String? desc]) {
      when(() => mockTogglerService.isEnabled).thenReturn(isEnabled);
      state = FeedState(book: b1, chapter: chapter, verse: verse);
      expect(testee.getNextVerse(state), expectValue);
    },
  );

  group('getNextVerse', () {
    test('returns 1 if no verse scopes', () {
      when(() => mockVerseScopes['b1']).thenReturn(null);
      expect(testee.getNextVerse(state), 1);
    });
  });

  group('getVerseScopeLabel', () {
    test('returns empty if toggler disabled', () {
      when(() => mockTogglerService.isEnabled).thenReturn(false);
      expect(testee.getVerseScopeLabel(state), '');
    });

    test('returns empty if no verse scope map', () {
      when(() => mockVerseScopes['b1']).thenReturn(null);
      expect(testee.getVerseScopeLabel(state), '');
    });

    test('returns empty if scope not applicable to chapter', () {
      expect(testee.getVerseScopeLabel(copyStateWith(chapter: 3)), '');
    });

    test('returns static name with underscores replaced', () {
      expect(testee.getVerseScopeLabel(state), 'ℵ\u00A0Aleph');
    });

    group('returns calculated name', () {
      test('to verse', () {
        expect(testee.getVerseScopeLabel(copyStateWith(chapter: 2)), 'to\u00A0verse\u00A02');
      });

      test('from verse', () {
        expect(testee.getVerseScopeLabel(copyStateWith(chapter: 2, verse: 3)), 'from\u00A0verse\u00A03');
      });
    });
  });
}
