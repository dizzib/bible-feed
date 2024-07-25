import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/feed.dart';

void main() {
  late Books bks;
  var b0 = Book('b0', 'Book0', 5);
  var b1 = Book('b1', 'Book1', 3);
  var b2 = Book('b2', 'Book2', 2);

  setUp(() {
    bks = Books('bks0', 'My book list', [ b0, b1, b2 ]);
  });

  test('constructor', () {
    expect(bks.count, 3);
    expect(bks.current, b0);
    expect(bks.progress, 0);
    expect(bks.totalChapters, 10);
  });

  test('[]', () {
    expect(bks[2], b2);
  });

  test('chaptersTo', () {
    expect(bks.chaptersTo(b0, 0), 0);
    expect(bks.chaptersTo(b1, 1), 6);
    expect(bks.chaptersTo(b2, 2), 10);
  });

  test('current get/set', () {
    bks.current = b2;
    expect(bks.current, b2);
  });

  test('getBook', () {
    expect(bks.getBook('b1').name, b1.name);
  });

  test('indexOf', () {
    expect(bks.indexOf(b2), 2);
  });

  test('nextBook should +1 and cycle', () {
    bks.nextBook(); expect(bks.current, b1);
    bks.nextBook(); expect(bks.current, b2);
    bks.nextBook(); expect(bks.current, b0);
  });

  test('progress', () {
    bks.current.isChapterRead = true;
    bks.current.nextChapter(); expect(bks.progress, 0.1);
  });

  test('progressTo', () {
    expect(bks.progressTo(b1, 1), 0.6);
  });
}
