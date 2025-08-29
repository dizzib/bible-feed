import 'dart:collection';

import 'package:injectable/injectable.dart';

@lazySingleton
class VerseScopes extends MapBase<String, dynamic> {
  final Map<String, dynamic> _map = {
    'mat': {26: 36},
    'luk': {1: 39},
    'jhn': {6: 41},
    'lev': {13: 29},
    'num': {7: 48},
    'deu': {28: 36},
    'psa': {
      119: {
        1: 'ℵ_Aleph__ℶ_Beth',
        17: 'ג_Gimel__ד_Daleth',
        33: 'ה_He__ו_Waw',
        49: 'ז_Zayin__ח_Heth',
        65: 'ט_Teth__י_Yod',
        81: 'כ_Kaph__ל_Lamed',
        97: 'מ_Mem__נ_Nun',
        113: 'ס_Samek__ע_Ayin',
        129: 'פ_Pe__צ_Tsadde',
        145: 'ק_Qoph__ר_Resh',
        161: 'ש_Shin__ת_Tau',
      }
    },
    '1ki': {8: 33},
    'neh': {7: 37},
    'jer': {51: 33},
    'act': {7: 30},
  };

  @override
  operator [](key) => _map[key];

  @override
  void operator []=(String key, dynamic value) => _map[key] = value;

  @override
  void clear() => _map.clear();

  @override
  Iterable<String> get keys => _map.keys;

  @override
  dynamic remove(Object? key) => _map.remove(key);
}
