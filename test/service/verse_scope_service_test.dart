import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:bible_feed/service/toggler_service.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVerseScopeTogglerService extends Mock implements VerseScopeTogglerService {}

void main() {
  late MockVerseScopeTogglerService mockTogglerService;
  late FeedState state;
  late VerseScopeService testee;

  setUp(() {
    mockTogglerService = MockVerseScopeTogglerService();
    testee = VerseScopeService(mockTogglerService);
    state = FeedState(
      book: const Book('b0', 'Book 0', 5, {
        1: {1: 'a_', 2: 'b'},
        2: {1: 'c'},
      }),
      chapter: 1,
      isRead: false,
    );
  });

  FeedState copyStateWith({Book? book, int? chapter, DateTime? dateModified, bool? isRead, int? verse}) {
    return FeedState(
        book: book ?? state.book,
        chapter: chapter ?? state.chapter,
        dateModified: dateModified ?? state.dateModified,
        isRead: isRead ?? state.isRead,
        verse: verse ?? state.verse);
  }

  group('VerseScopeService tests', () {
    test('nextVerse returns 1 if toggler disabled', () {
      when(() => mockTogglerService.isEnabled).thenReturn(false);
      expect(testee.nextVerse(state), 1);
    });

    test('nextVerse returns next verse in map if toggler enabled', () {
      when(() => mockTogglerService.isEnabled).thenReturn(true);
      expect(testee.nextVerse(state), 2);
    });

    test('nextVerse returns 1 if at last verse', () {
      when(() => mockTogglerService.isEnabled).thenReturn(true);
      final newState = copyStateWith(verse: 2);
      expect(testee.nextVerse(newState), 1);
    });

    test('nextVerse returns 1 if no verse scope map', () {
      when(() => mockTogglerService.isEnabled).thenReturn(true);
      final newState = copyStateWith(book: const Book('b1', 'Book 1', 3));
      expect(testee.nextVerse(newState), 1);
    });

    test('verseScopeName returns empty if toggler disabled', () {
      when(() => mockTogglerService.isEnabled).thenReturn(false);
      expect(testee.verseScopeName(state), '');
    });

    test('verseScopeName returns name with underscores replaced if toggler enabled', () {
      when(() => mockTogglerService.isEnabled).thenReturn(true);
      expect(testee.verseScopeName(state), 'a\u00A0');
    });

    test('verseScopeName returns empty if no verse scope map', () {
      when(() => mockTogglerService.isEnabled).thenReturn(true);
      final newState = copyStateWith(book: const Book('b1', 'Book 1', 3));
      expect(testee.verseScopeName(newState), '');
    });
  });
}
