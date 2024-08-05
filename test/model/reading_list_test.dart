import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/reading_list.dart';

void main() {
  var b0 = const Book('b0', 'Book0', 5);
  var b1 = const Book('b1', 'Book1', 3);
  var b2 = const Book('b2', 'Book2', 2);
  var l = ReadingList('bks0', 'My book list', [b0, b1, b2]);

  test('constructor', () {
    expect(l.count, 3);
    expect(l.totalChapters, 10);
  });

  test('[]', () {
    expect(l[0], b0);
    expect(l[1], b1);
    expect(l[2], b2);
  });

  test('chaptersTo', () {
    expect(l.chaptersTo(0, 0), 0);
    expect(l.chaptersTo(1, 1), 6);
    expect(l.chaptersTo(2, 2), 10);
  });

  test('getBook', () {
    expect(l.getBook('b0'), b0);
    expect(l.getBook('b1'), b1);
    expect(l.getBook('b2'), b2);
  });

  test('indexOf', () {
    expect(l.indexOf(b0), 0);
    expect(l.indexOf(b1), 1);
    expect(l.indexOf(b2), 2);
  });

  test('progressTo', () {
    expect(l.progressTo(0, 0), 0.0);
    expect(l.progressTo(1, 1), 0.6);
    expect(l.progressTo(2, 2), 1.0);
  });
}
