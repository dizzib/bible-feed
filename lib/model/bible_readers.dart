import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_list.dart';
import 'bible_reader.dart';
import 'bible_reader_key.dart';
import 'bible_reader_type.dart';
import 'book_key_externaliser.dart';
import 'uri_template.dart';

@immutable
@lazySingleton
class BibleReaders extends BaseList<BibleReader> {
  const BibleReaders(super._items);
}

// Android bible readers must be added to the queries section of AndroidManifest.xml.
@module
abstract class BibleReadersModule {
  @lazySingleton
  List<BibleReader> get bibleReader => [
    BibleReader(
      key: BibleReaderKey.none,
      type: BibleReaderType.none,
      name: 'None',
      uriTemplate: UriTemplate(''),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
    ),
    BibleReader(
      key: BibleReaderKey.andBibleApp,
      type: BibleReaderType.app,
      name: 'AndBible',
      uriTemplate: UriTemplate('https://read.andbible.org/BOOK.CHAPTER'),
      certifiedPlatforms: const [], // Deep links not working: https://github.com/AndBible/and-bible/issues/3210
    ),
    BibleReader(
      key: BibleReaderKey.blueLetterApp,
      type: BibleReaderType.app,
      name: 'Blue Letter Bible',
      uriTemplate: UriTemplate.byPlatform(android: 'blb://bible/BOOK/CHAPTER', iOS: 'blb://BOOK/CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.blueLetter,
      uriVersePath: '/VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.blueLetterWeb,
      type: BibleReaderType.web,
      name: 'Blue Letter Bible',
      uriTemplate: UriTemplate('https://www.blueletterbible.org/nkjv/BOOK/CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.blueLetter,
      uriVersePath: '/VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.lifeBibleApp,
      type: BibleReaderType.app,
      name: 'Life Bible',
      uriTemplate: UriTemplate('tecartabible://BOOK.CHAPTER'),
      certifiedPlatforms: const [],
    ),
    BibleReader(
      key: BibleReaderKey.logosBibleApp,
      type: BibleReaderType.app,
      name: 'Logos Bible',
      uriTemplate: UriTemplate('logosref:Bible.BOOK.CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.logos,
      uriVersePath: '.VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.oliveTreeApp,
      type: BibleReaderType.app,
      name: 'Olive Tree',
      uriTemplate: UriTemplate('olivetree://bible/BOOK.CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.oliveTree,
      uriVersePath: '.VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.weDevoteApp,
      type: BibleReaderType.app,
      name: 'WeDevote',
      uriTemplate: UriTemplate('wdbible://bible/BOOK.CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.osisParatext,
      uriVersePath: '.VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.youVersionApp,
      type: BibleReaderType.app,
      name: 'YouVersion',
      uriTemplate: UriTemplate('youversion://bible?reference=BOOK.CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.osisParatext,
      uriVersePath: '.VERSE',
    ),
  ];
}
