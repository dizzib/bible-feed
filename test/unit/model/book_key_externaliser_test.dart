import 'package:bible_feed/model/book_key_externaliser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/reading_lists.dart';

class ProdReadingListsModule extends ReadingListsModule {}

void main() {
  void runTest(BookKeyExternaliser testee, Map<String, String> expectedMappings) {
    final defaultMappings = <String, String>{};
    for (final readingList in ProdReadingListsModule().readingLists) {
      for (final book in readingList) {
        defaultMappings[book.key] = book.key;
      }
    }

    final mergedMappings = Map<String, String>.from(defaultMappings);
    mergedMappings.addAll(expectedMappings.map((k, v) => MapEntry(k, v)));

    group(testee.runtimeType.toString(), () {
      mergedMappings.forEach((from, to) {
        test('${testee.name}.getExternalBookKey "$from" should return "$to"', () {
          expect(testee.getExternalBookKey(from), to);
        });
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

  runTest(BookKeyExternaliser.openBible, const {
    '1cr': '1ch',
    '2cr': '2ch',
    '1jn': '1jo',
    '2jn': '2jo',
    '3jn': '3jo',
    'eze': 'eze',
    'jam': 'jam',
    'jdg': 'jug',
    'jhn': 'joh',
    'obd': 'oba',
    'prv': 'pro',
    'rth': 'rut',
    'sos': 'son',
  });
}
