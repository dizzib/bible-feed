import 'package:flutter_test/flutter_test.dart';

import '../test_data.dart';

void main() {
  test('constructor', () {
    expect(b1.chapterCount, 3);
    expect(b1.key, 'b1');
    expect(b1.name, 'Book 1');
  });
}
