import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_feed/data/store.dart';
import 'package:bible_feed/model/feed.dart';

void main() {
  late Feed f;
  late Book b0, b1;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'fd0.book': 'b1',
      'fd0.chapter': 3,
      'fd0.isChapterRead': true,
      'fd0.dateLastSaved': '2024-05-10T14:33:25.470094',
    });

    await Store.init();

    b0 = Book('b0', 'Book1', 5);
    b1 = Book('b1', 'Book1', 3);
    f = Feed(Books('fd0', 'Book list', [b0, b1]));
  });

  test('constructor should load state from store', () {
    expect(f.books.current, b1);
    expect(b1.chapter, 3);
    expect(b1.isChapterRead, true);
  });

  group('nextChapter', () {
    test('if read, should move to next book and save state to store', () {
      f.nextChapter();
      expect(f.books.current, b0);
      expect(b0.chapter, 1);
      expect(Store.getString('fd0.book'), 'b0');
      expect(Store.getInt('fd0.chapter'), 1);
    });
  });

  test('setBookAndChapter should reset current and save state to store', () {
    f.setBookAndChapter(b0, 4);
    expect(f.books.current, b0);
    expect(b0.chapter, 4);
    expect(b1.isChapterRead, false);
    expect(b1.chapter, 1);
    expect(Store.getString('fd0.book'), 'b0');
    expect(Store.getInt('fd0.chapter'), 4);
  });

  test('toggleIsChapterRead should toggle and save state to store', () {
    run(bool expectIsRead) {
      f.toggleIsChapterRead();
      expect(b1.isChapterRead, expectIsRead);
      expect(Store.getBool('fd0.isChapterRead'), expectIsRead);
    }
    run(false);
    run(true);
  });
}
