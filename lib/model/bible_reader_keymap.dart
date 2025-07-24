import 'package:flutter/foundation.dart';
import '/model/book.dart';

@immutable
abstract class BibleReaderKeyMap {
  const BibleReaderKeyMap();
  Map<String, String> get keyMap => {};

  @nonVirtual
  String apply(Book b) => keyMap[b.key] ?? b.key;
}

//// implementations

@immutable
class IdentityBibleReaderKeyMap extends BibleReaderKeyMap {
  const IdentityBibleReaderKeyMap();

  @override
  Map<String, String> get keyMap => const {};
}

@immutable
class BlueLetterBibleReaderKeyMap extends BibleReaderKeyMap {
  const BlueLetterBibleReaderKeyMap();

  @override
  Map<String, String> get keyMap => const {
        '1cr': '1ch',
        '2cr': '2ch',
        'jam': 'jas',
        'mar': 'mrk',
        'obd': 'oba',
        'prv': 'pro',
        'sos': 'sng',
      };
}

@immutable
// osis paratext with manual testing
class LogosBibleReaderKeyMap extends BibleReaderKeyMap {
  const LogosBibleReaderKeyMap();

  @override
  Map<String, String> get keyMap => const {
        '1cr': '1ch',
        '2cr': '2ch',
        'eze': 'ezk',
        'jam': 'jas',
        'mar': 'mrk',
        'obd': 'oba',
        'prv': 'pro',
        'rth': 'rut',
      };
}

@immutable
// see https://wiki.crosswire.org/OSIS_Book_Abbreviations
class OsisParatextBibleReaderKeyMap extends BibleReaderKeyMap {
  const OsisParatextBibleReaderKeyMap();

  @override
  Map<String, String> get keyMap => const {
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
      };
}

@immutable
class OliveTreeBibleReaderKeyMap extends BibleReaderKeyMap {
  const OliveTreeBibleReaderKeyMap();

  @override
  Map<String, String> get keyMap => const {
        'jhn': 'jn',
        '1cr': '1ch',
        '2cr': '2ch',
        'sos': 'ss',
      };
}
