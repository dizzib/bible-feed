import 'package:flutter/foundation.dart';

import '/model/book.dart';

@immutable
abstract class BibleReaderBookKeyMap {
  const BibleReaderBookKeyMap();
  Map<String, String> get keyMap => {};

  @nonVirtual
  String apply(Book b) => keyMap[b.key] ?? b.key;
}

//// implementations

@immutable
class IdentityBookKeyMap extends BibleReaderBookKeyMap {
  const IdentityBookKeyMap();

  @override
  Map<String, String> get keyMap => const {};
}

@immutable
class BlueLetterBookKeyMap extends BibleReaderBookKeyMap {
  const BlueLetterBookKeyMap();

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
class LogosBookKeyMap extends BibleReaderBookKeyMap {
  const LogosBookKeyMap();

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
class OsisParatextBookKeyMap extends BibleReaderBookKeyMap {
  const OsisParatextBookKeyMap();

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
class OliveTreeBookKeyMap extends BibleReaderBookKeyMap {
  const OliveTreeBookKeyMap();

  @override
  Map<String, String> get keyMap => const {'jhn': 'jn', '1cr': '1ch', '2cr': '2ch', 'sos': 'ss'};
}
