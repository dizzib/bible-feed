import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/reading_list.dart';

void main() {
  late ReadingList rl;
  var b0 = Book('b0', 'Book0', 5);
  var b1 = Book('b1', 'Book1', 3);
  var b2 = Book('b2', 'Book2', 2);

  setUp(() {
    rl = ReadingList('bks0', 'My book list', [ b0, b1, b2 ]);
  });

  test('constructor', () {
    expect(rl.count, 3);
    expect(rl.current, b0);
    expect(rl.progress, 0);
    expect(rl.totalChapters, 10);
  });

  test('[]', () {
    expect(rl[2], b2);
  });

  test('chaptersTo', () {
    expect(rl.chaptersTo(b0, 0), 0);
    expect(rl.chaptersTo(b1, 1), 6);
    expect(rl.chaptersTo(b2, 2), 10);
  });

  test('current get/set', () {
    rl.current = b2;
    expect(rl.current, b2);
  });

  test('getBook', () {
    expect(rl.getBook('b1').name, b1.name);
  });

  test('indexOf', () {
    expect(rl.indexOf(b2), 2);
  });

  test('nextBook should +1 and cycle', () {
    rl.nextBook(); expect(rl.current, b1);
    rl.nextBook(); expect(rl.current, b2);
    rl.nextBook(); expect(rl.current, b0);
  });

  test('progress', () {
    rl.current.isChapterRead = true;
    rl.current.nextChapter(); expect(rl.progress, 0.1);
  });

  test('progressTo', () {
    expect(rl.progressTo(b1, 1), 0.6);
  });
}
