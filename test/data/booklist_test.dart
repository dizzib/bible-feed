import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/data/feeds.dart';

void main() {
  test('total books', () {
    expect(bookList.length, 10);
  });

  test('total chapters per list', () {
    run(i, expectTotalChapters) => expect(bookList[i].totalChapters, expectTotalChapters);
    run(0, 89);
    run(1, 187);
    run(2, 78);
    run(3, 65);
    run(4, 62);
    run(5, 150);
    run(6, 31);
    run(7, 249);
    run(8, 250);
    run(9, 28);
  });
}