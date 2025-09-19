import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';

import '/model/book.dart';

@immutable
class BibleReaderBookKeyMap {
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

  const BibleReaderBookKeyMap(this.externalBookKeys);

  String apply(Book b) =>
      keyMap.entries.firstOrNullWhere((en) => en.value == b.key && externalBookKeys.contains(en.key))?.key ?? b.key;

  static const identity = BibleReaderBookKeyMap([]);

  static const blueLetter = BibleReaderBookKeyMap(['1ch', '2ch', 'jas', 'jde', 'mrk', 'oba', 'pro', 'sng']);
  static const logos = BibleReaderBookKeyMap(['1ch', '2ch', 'ezk', 'jas', 'mrk', 'oba', 'pro', 'rut']);
  static const oliveTree = BibleReaderBookKeyMap(['1ch', '2ch', 'jn', 'jde', 'ss']);

  static const osisParatext = BibleReaderBookKeyMap([
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
