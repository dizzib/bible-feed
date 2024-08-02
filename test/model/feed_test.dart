import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_feed/data/store.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/books.dart';
import 'package:bible_feed/model/feed.dart';

// helpers
extension MyDateExtension on DateTime { DateTime get date { return DateTime(year, month, day); } }

void main() {
  late Feed f;
  late Book b0, b1;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'fd0.book': 'b1',
      'fd0.chapter': 2,
      'fd0.isChapterRead': true,
      'fd0.dateLastSaved': '2024-05-10T14:33:25.470094',
    });

    await Store.init();

    b0 = Book('b0', 'Book1', 5);
    b1 = Book('b1', 'Book1', 3);
    f = Feed(ReadingList('fd0', 'Book list', [b0, b1]));
  });

  // store helpers
  String getStoredBookKey() => Store.getString('fd0.book')!;
  int getStoredChapter() => Store.getInt('fd0.chapter')!;
  bool getStoredIsChapterRead() => Store.getBool('fd0.isChapterRead')!;
  DateTime getStoredDateLastSaved() => DateTime.parse(Store.getString('fd0.dateLastSaved')!);

  // test helpers
  void checkBookChapterAndStore(Book expectedBook, int expectedChapter) {
    expect(f.readingList.current, expectedBook);
    expect(f.readingList.current.chapter, expectedChapter);
    expect(getStoredBookKey(), expectedBook.key);
    expect(getStoredChapter(), expectedChapter);
    expect(getStoredDateLastSaved().date, DateTime.now().date);
  }

  test('constructor should load state from store', () {
    expect(f.readingList.current, b1);
    expect(f.dateLastSaved, getStoredDateLastSaved());
    expect(b1.chapter, 2);
    expect(b1.isChapterRead, true);
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
      checkBookChapterAndStore(b0, 1);
    });
  });

  test('setBookAndChapter should reset current and save state to store', () {
    f.setBookAndChapter(b0, 4);
    checkBookChapterAndStore(b0, 4);
    expect(b1.isChapterRead, false);
    expect(b1.chapter, 1);
  });

  test('toggleIsChapterRead should toggle and save state to store', () {
    run(bool expectIsRead) {
      f.toggleIsChapterRead();
      expect(b1.isChapterRead, expectIsRead);
      expect(getStoredIsChapterRead(), expectIsRead);
      expect(getStoredDateLastSaved().date, DateTime.now().date);
    }
    run(false);
    run(true);
  });
}
