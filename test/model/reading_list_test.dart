import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/reading_list.dart';

void main() {
  late ReadingList rl;
  var b0 = const Book('b0', 'Book0', 5);
  var b1 = const Book('b1', 'Book1', 3);
  var b2 = const Book('b2', 'Book2', 2);

  setUp(() {
    rl = ReadingList('bks0', 'My book list', [ b0, b1, b2 ]);
  });

  test('constructor', () {
    expect(rl.count, 3);
    expect(rl.totalChapters, 10);
  });

  test('[]', () {
    expect(rl[2], b2);
  });

  test('chaptersTo', () {
    expect(rl.chaptersTo(0, 0), 0);
    expect(rl.chaptersTo(1, 1), 6);
    expect(rl.chaptersTo(2, 2), 10);
  });

  test('getBook', () {
    expect(rl.getBook('b1'), b1);
  });

  test('indexOf', () {
    expect(rl.indexOf(b2), 2);
  });

  test('progressTo', () {
    expect(rl.progressTo(1, 1), 0.6);
  });
}
