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
    BibleReader(
      key: BibleReaderKey.none,
      type: BibleReaderType.none,
      name: 'None',
      uriTemplate: '',
      certifiedPlatforms: [TargetPlatform.android, TargetPlatform.iOS],
    ),
    BibleReader(
      key: BibleReaderKey.andBibleApp,
      type: BibleReaderType.app,
      name: 'AndBible',
      uriTemplate: 'https://read.andbible.org/BOOK.CHAPTER',
      certifiedPlatforms: [], // Deep links not working: https://github.com/AndBible/and-bible/issues/3210
    ),
    BibleReader(
      key: BibleReaderKey.blueLetterApp,
      type: BibleReaderType.app,
      name: 'Blue Letter Bible',
      uriTemplate: 'blb://BOOK/CHAPTER',
      certifiedPlatforms: [TargetPlatform.iOS], // android has Open by default -> '0 verified links' and does not open!?
      bookKeyExternaliser: BookKeyExternaliser.blueLetter,
      uriVersePath: '/VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.blueLetterWeb,
      type: BibleReaderType.web,
      name: 'Blue Letter Bible',
      uriTemplate: 'https://www.blueletterbible.org/nkjv/BOOK/CHAPTER',
      certifiedPlatforms: [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.blueLetter,
      uriVersePath: '/VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.lifeBibleApp,
      type: BibleReaderType.app,
      name: 'Life Bible',
      uriTemplate: 'tecartabible://BOOK.CHAPTER',
      certifiedPlatforms: [],
    ),
    BibleReader(
      key: BibleReaderKey.logosBibleApp,
      type: BibleReaderType.app,
      name: 'Logos Bible',
      uriTemplate: 'logosref:Bible.BOOK.CHAPTER',
      certifiedPlatforms: [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.logos,
      uriVersePath: '.VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.oliveTreeApp,
      type: BibleReaderType.app,
      name: 'Olive Tree',
      uriTemplate: 'olivetree://bible/BOOK.CHAPTER',
      certifiedPlatforms: [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.oliveTree,
      uriVersePath: '.VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.weDevoteApp,
      type: BibleReaderType.app,
      name: 'WeDevote',
      uriTemplate: 'wdbible://bible/BOOK.CHAPTER',
      certifiedPlatforms: [TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.osisParatext,
      uriVersePath: '.VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.youVersionApp,
      type: BibleReaderType.app,
      name: 'YouVersion',
      uriTemplate: 'youversion://bible?reference=BOOK.CHAPTER',
      certifiedPlatforms: [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.osisParatext,
      uriVersePath: '.VERSE',
    ),
  ];
}
