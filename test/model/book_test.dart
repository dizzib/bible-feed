import 'package:flutter_test/flutter_test.dart';
import 'mock_book.dart';

void main() {
  test('constructor', () {
    expect(b0.chapterCount, 5);
    expect(b0.key, 'b0');
    expect(b0.name, 'Book 0');
  });
}
