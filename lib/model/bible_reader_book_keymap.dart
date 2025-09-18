import 'package:flutter/foundation.dart';
import '/model/book.dart';

@immutable
class BibleReaderBookKeyMap {
  final Map<String, String> keyMap;

  const BibleReaderBookKeyMap(this.keyMap);

  String apply(Book b) => keyMap[b.key] ?? b.key;

  /// Identity map with no key changes
  static const Identity = BibleReaderBookKeyMap({});

  /// BlueLetter key map
  static const BlueLetter = BibleReaderBookKeyMap({
    '1cr': '1ch',
    '2cr': '2ch',
    'jam': 'jas',
    'jud': 'jde',
    'mar': 'mrk',
    'obd': 'oba',
    'prv': 'pro',
    'sos': 'sng',
  });

  /// Logos key map
  static const Logos = BibleReaderBookKeyMap({
    '1cr': '1ch',
    '2cr': '2ch',
    'eze': 'ezk',
    'jam': 'jas',
    'mar': 'mrk',
    'obd': 'oba',
    'prv': 'pro',
    'rth': 'rut',
  });

  /// OsisParatext key map
  static const OsisParatext = BibleReaderBookKeyMap({
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

  /// OliveTree key map
  static const OliveTree = BibleReaderBookKeyMap({
    '1cr': '1ch',
    '2cr': '2ch',
    'jhn': 'jn',
    'jud': 'jde',
    'sos': 'ss',
  });
}
