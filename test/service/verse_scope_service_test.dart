import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/verse_scopes.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:bible_feed/service/verse_scope_toggler_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
    when(() => mockVerseScopes.containsKey('b2')).thenReturn(true);
    when(() => mockVerseScopes['b2']).thenReturn({
      1: {1: 'ℵ_Aleph', 2: 'ℶ_Beth'},
      2: 3,
    });
    when(() => mockTogglerService.isEnabled).thenReturn(true);
    testee = VerseScopeService(mockVerseScopes, mockTogglerService);
    state = FeedState(book: const Book('b2', 'Book 2', 3), chapter: 1, isRead: false);
  });

  FeedState copyStateWith({Book? book, int? chapter, int? verse}) => FeedState(
      book: book ?? state.book, chapter: chapter ?? state.chapter, isRead: state.isRead, verse: verse ?? state.verse);

  group('nextVerse', () {
    test('returns 1 if toggler disabled', () {
      when(() => mockTogglerService.isEnabled).thenReturn(false);
      expect(testee.nextVerse(state), 1);
    });

    test('returns next verse in map', () {
      expect(testee.nextVerse(state), 2);
    });

    test('returns 1 if at last verse', () {
      expect(testee.nextVerse(copyStateWith(verse: 2)), 1);
    });

    test('returns 1 if scope not applicable to chapter', () {
      expect(testee.nextVerse(copyStateWith(chapter: 3)), 1);
    });

    test('returns 1 if no verse scopes', () {
      when(() => mockVerseScopes.containsKey('b2')).thenReturn(false);
      expect(testee.nextVerse(state), 1);
    });
  });

  group('verseScopeName', () {
    test('returns empty if toggler disabled', () {
      when(() => mockTogglerService.isEnabled).thenReturn(false);
      expect(testee.verseScopeName(state), '');
    });

    test('returns empty if no verse scope map', () {
      when(() => mockVerseScopes.containsKey('b2')).thenReturn(false);
      expect(testee.verseScopeName(state), '');
    });

    test('returns empty if scope not applicable to chapter', () {
      expect(testee.verseScopeName(copyStateWith(chapter: 3)), '');
    });

    test('returns static name with underscores replaced', () {
      expect(testee.verseScopeName(state), 'ℵ\u00A0Aleph');
    });

    group('returns calculated name', () {
      test('to verse', () {
        expect(testee.verseScopeName(copyStateWith(chapter: 2)), 'to\u00A0verse\u00A02');
      });

      test('from verse', () {
        expect(testee.verseScopeName(copyStateWith(chapter: 2, verse: 3)), 'from\u00A0verse\u00A03');
      });
    });
  });
}
