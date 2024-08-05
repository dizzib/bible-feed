import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_feed/data/store.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/reading_list.dart';

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

    b0 = Book('b0', 'Book1', 5);
    b1 = Book('b1', 'Book1', 3);
    b2 = Book('b2', 'Book1', 2);
    f = Feed(ReadingList('rl0', 'Book list', [b0, b1, b2]));
  });

  /// helpers

  String getStoredBookKey() => Store.getString('rl0.book')!;
  int getStoredChapter() => Store.getInt('rl0.chapter')!;
  bool getStoredIsChapterRead() => Store.getBool('rl0.isChapterRead')!;
  DateTime getStoredDateLastSaved() => DateTime.parse(Store.getString('rl0.dateLastSaved')!);

  void checkBookChapterAndStore(Book expectedBook, int expectedChapter) {
    expect(f.current, expectedBook);
    expect(f.current.chapter, expectedChapter);
    expect(getStoredBookKey(), expectedBook.key);
    expect(getStoredChapter(), expectedChapter);
    expect(getStoredDateLastSaved().date, DateTime.now().date);
  }

  /// tests

  test('constructor should load state from store', () {
    expect(f.current, b1);
    expect(f.dateLastSaved, getStoredDateLastSaved());
    expect(b1.chapter, 2);
    expect(b1.isChapterRead, true);
  });

  group('property', () {
    test('current get/set', () {
      expect(f.current, b1); f.current = b2;
      expect(f.current, b2);
    });

    test('progress', () {
      f.current.nextChapter(); expect(f.progress, 0.7);
    });
  });

  group('method', () {
    test('nextBook should +1 and cycle', () {
      f.nextBook(); expect(f.current, b2);
      f.nextBook(); expect(f.current, b0);
      f.nextBook(); expect(f.current, b1);
    });

    group('nextChapter, if read', () {
      test('non-last chapter, should remain on current book and save state to store', () {
        f.nextChapter();
        checkBookChapterAndStore(b1, 3);
      });

      test('last chapter, should move to next book and save state to store', () {
        f.nextChapter();
        f.toggleIsChapterRead();
        f.nextChapter();
        checkBookChapterAndStore(b2, 1);
      });
    });

    test('setBookAndChapter should reset current and save state to store', () {
      f.setBookAndChapter(b0, 4);
      checkBookChapterAndStore(b0, 4);
      expect(b1.isChapterRead, false);
      expect(b1.chapter, 1);
    });

    test('toggleIsChapterRead should toggle and save state to store', () {
      f.toggleIsChapterRead(); expect(b1.isChapterRead, false); expect(getStoredIsChapterRead(), false);
      f.toggleIsChapterRead(); expect(b1.isChapterRead, true); expect(getStoredIsChapterRead(), true);
      expect(getStoredDateLastSaved().date, DateTime.now().date);
    });
  });
}
