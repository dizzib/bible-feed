import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/reading_list.dart';
import 'package:bible_feed/util/store.dart';

// helpers
extension MyDateExtension on DateTime { DateTime get date { return DateTime(year, month, day); } }

void main() {
  late Feed f;
  late Book b0, b1, b2;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'rl0.book': 'b1',
      'rl0.chapter': 2,
      'rl0.isChapterRead': true,
      'rl0.dateLastSaved': '2024-05-10T14:33:25.470094',
    });

    await Store.init();

    b0 = const Book('b0', 'Book1', 5);
    b1 = const Book('b1', 'Book1', 3);
    b2 = const Book('b2', 'Book1', 2);
    f = Feed(ReadingList('rl0', 'Book list', [b0, b1, b2]));
  });

  /// helpers

  String getStoredBookKey() => Store.getString('rl0.book')!;
  int getStoredChapter() => Store.getInt('rl0.chapter')!;
  bool getStoredIsChapterRead() => Store.getBool('rl0.isChapterRead')!;
  DateTime getStoredDateLastSaved() => DateTime.parse(Store.getString('rl0.dateLastSaved')!);

  void checkBookChapterAndStore(Book expectedBook, int expectedChapter) {
    expect(f.book, expectedBook);
    expect(f.chapter, expectedChapter);
    expect(getStoredBookKey(), expectedBook.key);
    expect(getStoredChapter(), expectedChapter);
    expect(getStoredDateLastSaved().date, DateTime.now().date);
  }

  /// tests

  test('constructor should load state from store', () {
    expect(f.book, b1);
    expect(f.dateLastSaved, getStoredDateLastSaved());
    expect(f.chapter, 2);
    expect(f.isChapterRead, true);
  });

  group('property', () {
    test('bookIndex get', () {
      expect(f.bookIndex, 1);
    });

    test('chapter get/set', () {
      f.chapter = 2;
      expect(f.chapter, 2);
    });

    test('current get/set', () {
      expect(f.book, b1); f.book = b2;
      expect(f.book, b2);
    });

    test('isChapterRead get/set should affect chaptersRead', () {
      expect(f.isChapterRead, true); expect(f.chaptersRead, 2); f.isChapterRead = false;
      expect(f.isChapterRead, false); expect(f.chaptersRead, 1);
    });

    test('progress get', () {
      f.nextChapter(); expect(f.progress, 0.7);
    });
  });

  group('method', () {
    test('nextBook should +1 and cycle', () {
      f.nextBook(); expect(f.book, b2);
      f.nextBook(); expect(f.book, b0);
      f.nextBook(); expect(f.book, b1);
    });

    group('nextChapter, if read', () {
      test('non-last chapter, should remain on current book and save state to store', () {
        f.nextChapter();
        checkBookChapterAndStore(b1, 3);
      });

      next() { f.isChapterRead = true; f.nextChapter(); }

      test('should fail assertion if not read', () {
        f.isChapterRead = false;
        expect(f.nextChapter, throwsAssertionError);
      });

      test('should +1 chapter and cycle', () {
        next(); expect(f.chapter, 3);
        next(); expect(f.chapter, 1);
        next(); expect(f.chapter, 2);
      });

      test('should +0 chaptersRead', () {
        expect(f.chaptersRead, 2); next();
        expect(f.chaptersRead, 2);
      });

      test('should reset isChapterRead', () {
        next(); expect(f.isChapterRead, false);
      });

      test('last chapter, should move to next book and save state to store', () {
        f.nextChapter();
        f.toggleIsChapterRead();
        f.nextChapter();
        checkBookChapterAndStore(b2, 1);
      });
    });

    test('setBookAndChapter should reset current and save state to store', () {
      f.setBookAndChapter(0, 4);
      checkBookChapterAndStore(b0, 4);
      expect(f.isChapterRead, false);
    });

    test('toggleIsChapterRead should toggle and save state to store', () {
      f.toggleIsChapterRead(); expect(f.isChapterRead, false); expect(getStoredIsChapterRead(), false);
      f.toggleIsChapterRead(); expect(f.isChapterRead, true); expect(getStoredIsChapterRead(), true);
      expect(getStoredDateLastSaved().date, DateTime.now().date);
    });
  });
}
