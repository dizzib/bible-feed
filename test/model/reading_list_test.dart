import 'package:flutter_test/flutter_test.dart';
import '_test_data.dart';

void main() {

  test('constructor', () {
    expect(l2.count, 3);
    expect(l2.totalChapters, 10);
  });

  test('[]', () {
    expect(l2[0], b0);
    expect(l2[1], b1);
    expect(l2[2], b2);
  });

  test('chaptersTo', () {
    expect(l2.chaptersTo(0, 0), 0);
    expect(l2.chaptersTo(1, 1), 6);
    expect(l2.chaptersTo(2, 2), 10);
  });

  test('getBook', () {
    expect(l2.getBook('b0'), b0);
    expect(l2.getBook('b1'), b1);
    expect(l2.getBook('b2'), b2);
  });

  test('indexOf', () {
    expect(l2.indexOf(b0), 0);
    expect(l2.indexOf(b1), 1);
    expect(l2.indexOf(b2), 2);
  });

  test('progressTo', () {
    expect(l2.progressTo(0, 0), 0.0);
    expect(l2.progressTo(1, 1), 0.6);
    expect(l2.progressTo(2, 2), 1.0);
  });
}
