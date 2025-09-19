import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';

@immutable
class BookKeyExternaliser {
  const BookKeyExternaliser(this._externalBookKeys);

  // Bible reader external key : BibleFeed internal key
  static const _keyMap = {
    'jn': 'jhn',
    'ss': 'sos',
    '1ch': '1cr',
    '2ch': '2cr',
    'ezk': 'eze',
    'jas': 'jam',
    'jde': 'jud',
    'jol': 'joe',
    'mrk': 'mar',
    'nam': 'nah',
    'oba': 'obd',
    'pro': 'prv',
    'rut': 'rth',
    'sng': 'sos',
  };

  static const _ext0Keys = ['1ch', '2ch'];
  static const _ext1Keys = [..._ext0Keys, 'mrk', 'oba', 'pro'];
  static const _ext2Keys = [..._ext1Keys, 'ezk', 'jas', 'rut'];

  final List<String> _externalBookKeys;

  String getExternalBookKey(String bookKey) =>
      _keyMap.entries.firstOrNullWhere((en) => en.value == bookKey && _externalBookKeys.contains(en.key))?.key ??
      bookKey;

  static const identity = BookKeyExternaliser([]);
  static const blueLetter = BookKeyExternaliser([..._ext1Keys, 'jas', 'jde', 'sng']);
  static const logos = BookKeyExternaliser([..._ext2Keys]);
  static const oliveTree = BookKeyExternaliser([..._ext0Keys, 'jn', 'jde', 'ss']);
  static const osisParatext = BookKeyExternaliser([..._ext2Keys, 'jol', 'nam', 'sng']);
}
