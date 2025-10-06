import 'package:bible_feed/model/bible_reader_key.dart';
import 'package:bible_feed/model/book_key_externaliser.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_data.dart';

void main() {
  group('field getters', () {
    test('noneBibleReader', () {
      expect(noneBibleReader.key, BibleReaderKey.none);
      expect(noneBibleReader.name, '');
      expect(noneBibleReader.certifiedPlatforms, []);
      expect(noneBibleReader.uriTemplate, '');
      expect(noneBibleReader.bookKeyExternaliser, BookKeyExternaliser.identity);
    });

    test('blbBibleReader', () {
      expect(blbBibleReader.key, BibleReaderKey.blueLetterApp);
      expect(blbBibleReader.name, 'name');
      expect(blbBibleReader.certifiedPlatforms, []);
      expect(blbBibleReader.uriTemplate, 'scheme://uri/BOOK/CHAPTER');
      expect(blbBibleReader.uriVersePath, '/VERSE');
      expect(blbBibleReader.bookKeyExternaliser, BookKeyExternaliser.blueLetter);
    });
  });

  group('calculated getters', () {
    test('noneBibleReader', () {
      expect(noneBibleReader.displayName, '');
      expect(noneBibleReader.isApp, false);
      expect(noneBibleReader.isNone, true);
    });

    test('blbBibleReader', () {
      expect(blbBibleReader.displayName, 'name app');
      expect(blbBibleReader.isApp, true);
      expect(blbBibleReader.isNone, false);
    });
  });
}
