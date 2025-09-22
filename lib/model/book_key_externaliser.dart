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

  final List<String> _externalBookKeys;

  String getExternalBookKey(String internalBookKey) =>
      _keyMap.entries
          .firstOrNullWhere((en) => en.value == internalBookKey && _externalBookKeys.contains(en.key))
          ?.key ??
      internalBookKey;

  static const identity = BookKeyExternaliser([]);
}
