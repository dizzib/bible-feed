import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_list.dart';
import 'bible_reader.dart';
import 'bible_reader_key.dart';
import 'bible_reader_type.dart';
import 'book_key_externaliser.dart';

@immutable
@lazySingleton
class BibleReaders extends BaseList<BibleReader> {
  const BibleReaders(super._items);
}

@module
abstract class BibleReadersModule {
  @lazySingleton
  List<BibleReader> get bibleReader => const [
    BibleReader(BibleReaderKey.none, BibleReaderType.none, 'None', '', [TargetPlatform.android, TargetPlatform.iOS]),
    BibleReader(
      BibleReaderKey.andBibleApp,
      BibleReaderType.app,
      'AndBible',
      'https://read.andbible.org/BOOK.CHAPTER',
      [], // Deep links not working: https://github.com/AndBible/and-bible/issues/3210
    ),
    BibleReader(
      BibleReaderKey.blueLetterApp,
      BibleReaderType.app,
      'Blue Letter Bible',
      'blb://BOOK/CHAPTER',
      [TargetPlatform.iOS], // android has Open by default -> '0 verified links' and does not open!?
      bookKeyExternaliser: BookKeyExternaliser.blueLetter,
      uriVersePath: '/VERSE',
    ),
    BibleReader(
      BibleReaderKey.blueLetterWeb,
      BibleReaderType.web,
      'Blue Letter Bible',
      'https://www.blueletterbible.org/nkjv/BOOK/CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.blueLetter,
      uriVersePath: '/VERSE',
    ),
    BibleReader(BibleReaderKey.lifeBibleApp, BibleReaderType.app, 'Life Bible', 'tecartabible://BOOK.CHAPTER', []),
    BibleReader(
      BibleReaderKey.logosBibleApp,
      BibleReaderType.app,
      'Logos Bible',
      'logosref:Bible.BOOK.CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.logos,
      uriVersePath: '.VERSE',
    ),
    BibleReader(
      BibleReaderKey.oliveTreeApp,
      BibleReaderType.app,
      'Olive Tree',
      'olivetree://bible/BOOK.CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.oliveTree,
      uriVersePath: '.VERSE',
    ),
    BibleReader(
      BibleReaderKey.weDevoteApp,
      BibleReaderType.app,
      'WeDevote',
      'wdbible://bible/BOOK.CHAPTER',
      [TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.osisParatext,
      uriVersePath: '.VERSE',
    ),
    BibleReader(
      BibleReaderKey.youVersionApp,
      BibleReaderType.app,
      'YouVersion',
      'youversion://bible?reference=BOOK.CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.osisParatext,
      uriVersePath: '.VERSE',
    ),
  ];
}
