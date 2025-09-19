import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';

import '/model/book.dart';

@immutable
class BibleReaderBookKeyExternaliser {
  final List<String> externalBookKeys;

  // Bible reader external key : BibleFeed internal key
  static const keyMap = {
    '1ch': '1cr',
    '2ch': '2cr',
    'ezk': 'eze',
    'jas': 'jam',
    'jde': 'jud',
    'jn': 'jhn',
    'jol': 'joe',
    'mrk': 'mar',
    'nam': 'nah',
    'oba': 'obd',
    'pro': 'prv',
    'rut': 'rth',
    'sng': 'sos',
    'ss': 'sos',
  };

  const BibleReaderBookKeyExternaliser(this.externalBookKeys);

  String apply(Book b) =>
      keyMap.entries.firstOrNullWhere((en) => en.value == b.key && externalBookKeys.contains(en.key))?.key ?? b.key;

  static const identity = BibleReaderBookKeyExternaliser([]);

  static const blueLetter = BibleReaderBookKeyExternaliser(['1ch', '2ch', 'jas', 'jde', 'mrk', 'oba', 'pro', 'sng']);
  static const logos = BibleReaderBookKeyExternaliser(['1ch', '2ch', 'ezk', 'jas', 'mrk', 'oba', 'pro', 'rut']);
  static const oliveTree = BibleReaderBookKeyExternaliser(['1ch', '2ch', 'jn', 'jde', 'ss']);

  static const osisParatext = BibleReaderBookKeyExternaliser([
    '1ch',
    '2ch',
    'ezk',
    'jas',
    'jol',
    'mrk',
    'nam',
    'oba',
    'pro',
    'rut',
    'sng',
  ]);
}
