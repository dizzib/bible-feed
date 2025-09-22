import 'package:flutter/foundation.dart';

import '/model/book_key_externaliser.dart' as base;

@immutable
class BookKeyExternaliser extends base.BookKeyExternaliser {
  const BookKeyExternaliser(super._externalBookKeys);

  static const _ext0Keys = ['1ch', '2ch'];
  static const _ext1Keys = [..._ext0Keys, 'mrk', 'oba', 'pro'];
  static const _ext2Keys = [..._ext1Keys, 'ezk', 'jas', 'rut'];

  static const identity = BookKeyExternaliser([]);
  static const blueLetter = BookKeyExternaliser([..._ext1Keys, 'jas', 'jde', 'sng']);
  static const logos = BookKeyExternaliser([..._ext2Keys]);
  static const oliveTree = BookKeyExternaliser([..._ext0Keys, 'jn', 'jde', 'ss']);
  static const osisParatext = BookKeyExternaliser([..._ext2Keys, 'jol', 'nam', 'sng']);
}
