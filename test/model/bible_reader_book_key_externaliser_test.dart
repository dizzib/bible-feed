import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/bible_reader_book_key_externaliser.dart';
import 'package:bible_feed/model/book.dart';

void main() {
  Book createBook(String key) => Book(key, '', 1);

  void testMapping(BibleReaderBookKeyExternaliser map, Map<String, String> knownMappings) {
    group(map.runtimeType.toString(), () {
      knownMappings.forEach((input, expected) {
        test('apply maps "$input" to "$expected"', () {
          expect(map.apply(createBook(input)), equals(expected));
        });
      });

      test('apply returns original key for unknown keys', () {
        expect(map.apply(createBook('unknown')), equals('unknown'));
      });
    });
  }

  group('BibleReaderBookKeyExternaliser', () {
    test('apply returns original key if not in keyMap', () {
      final map = const _TestBookKeyExternaliser();
      expect(map.apply(createBook('unknown')), equals('unknown'));
    });
  });

  test('identity apply returns original key unchanged', () {
    expect(BibleReaderBookKeyExternaliser.identity.apply(createBook('anykey')), equals('anykey'));
  });

  testMapping(BibleReaderBookKeyExternaliser.blueLetter, const {
    '1cr': '1ch',
    '2cr': '2ch',
    'jam': 'jas',
    'jud': 'jde',
    'mar': 'mrk',
    'obd': 'oba',
    'prv': 'pro',
    'sos': 'sng',
  });

  testMapping(BibleReaderBookKeyExternaliser.logos, const {
    '1cr': '1ch',
    '2cr': '2ch',
    'eze': 'ezk',
    'jam': 'jas',
    'mar': 'mrk',
    'obd': 'oba',
    'prv': 'pro',
    'rth': 'rut',
  });

  testMapping(BibleReaderBookKeyExternaliser.osisParatext, const {
    '1cr': '1ch',
    '2cr': '2ch',
    'eze': 'ezk',
    'jam': 'jas',
    'joe': 'jol',
    'mar': 'mrk',
    'nah': 'nam',
    'obd': 'oba',
    'prv': 'pro',
    'rth': 'rut',
    'sos': 'sng',
  });

  testMapping(BibleReaderBookKeyExternaliser.oliveTree, const {
    '1cr': '1ch',
    '2cr': '2ch',
    'jhn': 'jn',
    'jud': 'jde',
    'sos': 'ss',
  });
}

// Helper class for testing concrete class
class _TestBookKeyExternaliser extends BibleReaderBookKeyExternaliser {
  const _TestBookKeyExternaliser() : super(const []);
}
