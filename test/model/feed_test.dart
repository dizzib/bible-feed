import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/util/date.dart';
import 'package:bible_feed/util/store.dart';
import '_test_data.dart';

void main() {
  late Feed f;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'l2.book': 'b1',
      'l2.chapter': 2,
      'l2.isChapterRead': true,
      'l2.dateLastSaved': '2024-05-10T14:33:25.470094',
    });

    await Store.init();
    f = Feed(l2);
  });

  DateTime getStoredDateLastSaved() => DateTime.parse(Store.getString('l2.dateLastSaved')!);

  test('constructor should load state from store', () {
    expect(f.book, b1);
    expect(f.chapter, 2);
    expect(f.isChapterRead, true);
    expect(f.dateLastSaved, getStoredDateLastSaved());
  });

  group('property', () {
    test('bookIndex get', () {
      expect(f.bookIndex, 1);
    });

    test('chapter get/set', () {
      expect(f.chapter, 2); f.chapter = 1;
      expect(f.chapter, 1);
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
    void checkBookChapterAndStore(Book expectedBook, int expectedChapter) {
      expect(f.book, expectedBook);
      expect(f.chapter, expectedChapter);
      expect(Store.getString('l2.book')!, expectedBook.key);
      expect(Store.getInt('l2.chapter')!, expectedChapter);
      expect(getStoredDateLastSaved().date, DateTime.now().date);
    }

    group('nextChapter', () {
      next() { f.isChapterRead = true; f.nextChapter(); }

      test('should fail assertion if not read', () {
        f.isChapterRead = false;
        expect(f.nextChapter, throwsAssertionError);
      });

      test('full cycle: should advance/reset chapter and book, and store', () {
        next(); checkBookChapterAndStore(b1, 3);
        next(); checkBookChapterAndStore(b2, 1);
        next(); checkBookChapterAndStore(b2, 2);
        next(); checkBookChapterAndStore(b0, 1);
        next(); checkBookChapterAndStore(b0, 2);
        next(); checkBookChapterAndStore(b0, 3);
        next(); checkBookChapterAndStore(b0, 4);
        next(); checkBookChapterAndStore(b0, 5);
        next(); checkBookChapterAndStore(b1, 1);
        next(); checkBookChapterAndStore(b1, 2);
        next(); checkBookChapterAndStore(b1, 3);
      });

      test('should +0 chaptersRead', () {
        expect(f.chaptersRead, 2); next();
        expect(f.chaptersRead, 2);
      });

      test('should reset isChapterRead', () {
        next(); expect(f.isChapterRead, false);
      });
    });

    test('setBookAndChapter should set book/chapter, reset isChapterRead, and store', () {
      f.setBookAndChapter(0, 4);
      checkBookChapterAndStore(b0, 4);
      expect(f.isChapterRead, false);
    });

    test('toggleIsChapterRead should toggle and store', () {
      void checkIsChapterRead(bool expected) {
        expect(f.isChapterRead, expected);
        expect(Store.getBool('l2.isChapterRead')!, expected);
      }

      f.toggleIsChapterRead(); checkIsChapterRead(false);
      f.toggleIsChapterRead(); checkIsChapterRead(true);
      checkBookChapterAndStore(b1, 2);  // ensure no side effects
    });
  });
}
