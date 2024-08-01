import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/feed.dart';

void main() {
  late Book b;

  setUp(() {
    b = Book('bk', 'Book', 3);
  });

  test('constructor', () {
    expect(b.chapter, 1);
    expect(b.chaptersRead, 0);
    expect(b.chapterCount, 3);
    expect(b.isChapterRead, false);
    expect(b.key, 'bk');
    expect(b.name, 'Book');
  });

  test('chapter get/set', () {
    b.chapter = 2;
    expect(b.chapter, 2);
  });

  test('isChapterRead should +1 chaptersRead', () {
    b.isChapterRead = true;
    expect(b.chaptersRead, 1);
  });

  group('nextChapter', () {
    next() { b.isChapterRead = true; b.nextChapter(); }

    test('should fail assertion if not read', () {
      expect(b.nextChapter, throwsAssertionError);
    });

    test('should +1 chapter and cycle', () {
      next(); expect(b.chapter, 2);
      next(); expect(b.chapter, 3);
      next(); expect(b.chapter, 1);
    });

    test('should +0 chaptersRead', () {
      next(); expect(b.chaptersRead, 1);
    });

    test('should reset isChapterRead', () {
      next(); expect(b.isChapterRead, false);
    });
  });
}
