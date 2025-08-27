import 'package:flutter_test/flutter_test.dart';

import '../test_data.dart';

void main() {
  test('constructor', () {
    expect(rl2.count, 3);
    expect(rl2.totalChapters, 10);
  });

  test('[]', () {
    expect(rl2[0], b0);
    expect(rl2[1], b1);
    expect(rl2[2], b2);
  });

  test('chaptersTo', () {
    expect(rl2.chaptersTo(0, 0), 0);
    expect(rl2.chaptersTo(1, 1), 6);
    expect(rl2.chaptersTo(2, 2), 10);
  });

  test('getBook', () {
    expect(rl2.getBook('b0'), b0);
    expect(rl2.getBook('b1'), b1);
    expect(rl2.getBook('b2'), b2);
  });

  test('indexOf', () {
    expect(rl2.indexOf(b0), 0);
    expect(rl2.indexOf(b1), 1);
    expect(rl2.indexOf(b2), 2);
  });

  test('progressTo', () {
    expect(rl2.progressTo(0, 0), 0.0);
    expect(rl2.progressTo(1, 1), 0.6);
    expect(rl2.progressTo(2, 2), 1.0);
  });
}
