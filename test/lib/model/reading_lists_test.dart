import 'package:bible_feed/model/reading_lists.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../../injectable.dart';

void main() async {
  await configureDependencies('test');

  final testee = sl<ReadingLists>();

  test('total reading lists should be 10', () {
    expect(testee.length, 10);
  });

  test('total chapters per list', () {
    run(i, expectTotalChapters) => expect(testee[i].totalChapters, expectTotalChapters);

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
