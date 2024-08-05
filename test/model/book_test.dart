import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/book.dart';

void main() {
  late Book b;

  setUp(() {
    b = const Book('bk', 'Book', 3);
  });

  test('constructor', () {
    expect(b.chapterCount, 3);
    expect(b.key, 'bk');
    expect(b.name, 'Book');
  });
}
