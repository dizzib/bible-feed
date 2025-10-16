import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_list.dart';
import 'bible_reader.dart';
import 'bible_reader_key.dart';
import 'bible_reader_type.dart';
import 'book_key_externaliser.dart';
import 'url_template.dart';

@immutable
@lazySingleton
class BibleReaders extends BaseList<BibleReader> {
  const BibleReaders(super._items);
}

// Android bible readers must be added to the queries section of AndroidManifest.xml.
// IOS bible reader schemes must be added to LSApplicationQueriesSchemes in Info.plist.
//
// Certain Bible readers are uncertified due to the following issues:
//
// Accordance Bible ios: accord://read/John+3:17 displays verse 17 in isolation
// AndBible: see below
// Life Bible: see below
// WeDevote android: not detected
//
@module
abstract class BibleReadersModule {
  @lazySingleton
  List<BibleReader> get bibleReader => [
    BibleReader(
      key: BibleReaderKey.none,
      type: BibleReaderType.none,
      name: 'None',
      urlTemplate: UrlTemplate(''),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
    ),
    BibleReader(
      key: BibleReaderKey.andBibleApp,
      type: BibleReaderType.app,
      name: 'AndBible',
      urlTemplate: UrlTemplate('https://read.andbible.org/BOOK.CHAPTER'),
      // Not certified because deep links are not working: https://github.com/AndBible/and-bible/issues/3210
    ),
    BibleReader(
      key: BibleReaderKey.blueLetterApp,
      type: BibleReaderType.app,
      name: 'Blue Letter Bible',
      urlTemplate: UrlTemplate.byPlatform(android: 'blb://bible/BOOK/CHAPTER', iOS: 'blb://BOOK/CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.blueLetter,
      urlVersePath: '/VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.blueLetterWeb,
      type: BibleReaderType.web,
      name: 'Blue Letter Bible',
      urlTemplate: UrlTemplate('https://www.blueletterbible.org/nkjv/BOOK/CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.blueLetter,
      urlVersePath: '/VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.lifeBibleApp,
      type: BibleReaderType.app,
      name: 'Life Bible',
      urlTemplate: UrlTemplate('tecartabible://BOOK CHAPTER'), // 'https://tecartabible.com/bible/BOOK+CHAPTER'
      // Not certified due to these issues:
      // - :VERSE works only via https
      // - forcibly reverts translation over https
      // - 3-letter book keys are not documented, but mostly work on ios or over https on android (e.g. 2 chronicles broken)
      // - android back button works but needs 2 taps
      urlVersePath: ':VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.logosBibleApp,
      type: BibleReaderType.app,
      name: 'Logos Bible',
      urlTemplate: UrlTemplate('logosref:Bible.BOOK.CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.logos,
      urlVersePath: '.VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.oliveTreeApp,
      type: BibleReaderType.app,
      name: 'Olive Tree',
      urlTemplate: UrlTemplate('olivetree://bible/BOOK.CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.oliveTree,
      urlVersePath: '.VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.weDevoteApp,
      type: BibleReaderType.app,
      name: 'WeDevote',
      urlTemplate: UrlTemplate('wdbible://bible/BOOK.CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.iOS], // not detected on android
      bookKeyExternaliser: BookKeyExternaliser.osisParatext,
      urlVersePath: '.VERSE',
    ),
    BibleReader(
      key: BibleReaderKey.youVersionApp,
      type: BibleReaderType.app,
      name: 'YouVersion',
      urlTemplate: UrlTemplate('youversion://bible?reference=BOOK.CHAPTER'),
      certifiedPlatforms: const [TargetPlatform.android, TargetPlatform.iOS],
      bookKeyExternaliser: BookKeyExternaliser.osisParatext,
      urlVersePath: '.VERSE',
    ),
  ];
}
