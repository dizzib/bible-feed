import 'package:bible_feed/model/book_key_externaliser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  void runTest(BookKeyExternaliser testee, Map<String, String> knownMappings) {
    group(testee.runtimeType.toString(), () {
      knownMappings.forEach((from, to) {
        test('getExternalBookKey "$from" should return "$to"', () {
          expect(testee.getExternalBookKey(from), to);
        });
      });

      test('getExternalBookKey returns original key for unknown keys', () {
        expect(testee.getExternalBookKey('unknown'), 'unknown');
      });
    });
  }

  runTest(BookKeyExternaliser.identity, const {});

  runTest(BookKeyExternaliser.blueLetter, const {
    '1cr': '1ch',
    '2cr': '2ch',
    'jam': 'jas',
    'jud': 'jde',
    'mar': 'mrk',
    'obd': 'oba',
    'prv': 'pro',
    'sos': 'sng',
  });

  runTest(BookKeyExternaliser.logos, const {
    '1cr': '1ch',
    '2cr': '2ch',
    'eze': 'ezk',
    'jam': 'jas',
    'mar': 'mrk',
    'obd': 'oba',
    'prv': 'pro',
    'rth': 'rut',
  });

  runTest(BookKeyExternaliser.osisParatext, const {
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

  runTest(BookKeyExternaliser.oliveTree, const {'1cr': '1ch', '2cr': '2ch', 'jhn': 'jn', 'jud': 'jde', 'sos': 'ss'});
}
