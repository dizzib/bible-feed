import 'package:dartx/dartx.dart';

enum BookKeyExternaliser {
  identity([]),
  blueLetter([..._ext1Keys, 'jas', 'jde', 'sng']),
  logos([..._ext2Keys]),
  oliveTree([..._ext0Keys, 'jn', 'jde', 'ss']),
  openBible([..._ext1Keys, '1jo', '2jo', '3jo', 'jug', 'joh', 'rut', 'son']),
  osisParatext([..._ext2Keys, 'jol', 'nam', 'sng']);

  static const _ext0Keys = ['1ch', '2ch'];
  static const _ext1Keys = [..._ext0Keys, 'mrk', 'oba', 'pro'];
  static const _ext2Keys = [..._ext1Keys, 'ezk', 'jas', 'rut'];

  // Bible reader external key : BibleFeed internal key
  static const _keyMap = {
    'jn': 'jhn',
    'ss': 'sos',
    '1ch': '1cr',
    '2ch': '2cr',
    '1jo': '1jn',
    '2jo': '2jn',
    '3jo': '3jn',
    'ezk': 'eze',
    'jas': 'jam',
    'jde': 'jud',
    'joh': 'jhn',
    'jol': 'joe',
    'jug': 'jdg',
    'mrk': 'mar',
    'nam': 'nah',
    'oba': 'obd',
    'pro': 'prv',
    'rut': 'rth',
    'sng': 'sos',
    'son': 'sos',
  };

  final List<String> _externalBookKeys;

  const BookKeyExternaliser(this._externalBookKeys);

  String getExternalBookKey(String internalBookKey) =>
      _keyMap.entries
          .firstOrNullWhere((en) => en.value == internalBookKey && _externalBookKeys.contains(en.key))
          ?.key ??
      internalBookKey;
}
