import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';

@immutable
class BookKeyExternaliser {
  const BookKeyExternaliser(this.externalBookKeys);

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

  final List<String> externalBookKeys;

  String apply(String bookKey) =>
      keyMap.entries.firstOrNullWhere((en) => en.value == bookKey && externalBookKeys.contains(en.key))?.key ?? bookKey;

  static const identity = BookKeyExternaliser([]);

  static const blueLetter = BookKeyExternaliser(['1ch', '2ch', 'jas', 'jde', 'mrk', 'oba', 'pro', 'sng']);

  static const logos = BookKeyExternaliser(['1ch', '2ch', 'ezk', 'jas', 'mrk', 'oba', 'pro', 'rut']);

  static const oliveTree = BookKeyExternaliser(['1ch', '2ch', 'jn', 'jde', 'ss']);

  static const osisParatext = BookKeyExternaliser([
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
