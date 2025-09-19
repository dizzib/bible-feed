import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/book_key_externaliser.dart';

void main() {
  void testMapping(BookKeyExternaliser testee, Map<String, String> knownMappings) {
    group(testee.runtimeType.toString(), () {
      knownMappings.forEach((input, expected) {
        test('apply "$input" should return "$expected"', () {
          expect(testee.apply(input), expected);
        });
      });

      test('apply returns original key for unknown keys', () {
        expect(testee.apply('unknown'), 'unknown');
      });
    });
  }

  group('BibleReaderBookKeyExternaliser', () {
    test('apply returns original key if not in keyMap', () {
      expect(const _TestBookKeyExternaliser().apply('unknown'), 'unknown');
    });
  });

  test('identity apply returns original key unchanged', () {
    expect(BookKeyExternaliser.identity.apply('anykey'), 'anykey');
  });

  testMapping(BookKeyExternaliser.blueLetter, const {
    '1cr': '1ch',
    '2cr': '2ch',
    'jam': 'jas',
    'jud': 'jde',
    'mar': 'mrk',
    'obd': 'oba',
    'prv': 'pro',
    'sos': 'sng',
  });

  testMapping(BookKeyExternaliser.logos, const {
    '1cr': '1ch',
    '2cr': '2ch',
    'eze': 'ezk',
    'jam': 'jas',
    'mar': 'mrk',
    'obd': 'oba',
    'prv': 'pro',
    'rth': 'rut',
  });

  testMapping(BookKeyExternaliser.osisParatext, const {
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

  testMapping(BookKeyExternaliser.oliveTree, const {
    '1cr': '1ch',
    '2cr': '2ch',
    'jhn': 'jn',
    'jud': 'jde',
    'sos': 'ss',
  });
}

// Helper class for testing concrete class
class _TestBookKeyExternaliser extends BookKeyExternaliser {
  const _TestBookKeyExternaliser() : super(const []);
}
