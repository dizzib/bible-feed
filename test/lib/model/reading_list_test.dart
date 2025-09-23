import 'package:flutter_test/flutter_test.dart';

import '../test_data.dart';

void main() {
  test('constructor', () {
    expect(rl1.count, 2);
    expect(rl1.totalChapters, 4);
  });

  test('[]', () {
    expect(rl1[0], b0);
    expect(rl1[1], b1);
  });

  test('chaptersTo', () {
    expect(rl1.chaptersTo(0, 0), 0);
    expect(rl1.chaptersTo(1, 2), 3);
  });

  test('getBook', () {
    expect(rl1.getBook('b0'), b0);
    expect(rl1.getBook('b1'), b1);
  });

  test('indexOf', () {
    expect(rl1.indexOf(b0), 0);
    expect(rl1.indexOf(b1), 1);
  });

  test('progressTo', () {
    expect(rl1.progressTo(0, 0), 0.0);
    expect(rl1.progressTo(1, 0), 0.25);
    expect(rl1.progressTo(1, 1), 0.5);
    expect(rl1.progressTo(1, 2), 0.75);
    expect(rl1.progressTo(1, 3), 1.0);
  });
}
