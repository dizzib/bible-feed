import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'bible_reader.dart';
import 'bible_reader_book_keymap.dart';

enum BibleReaderKey {
  none,
  andBibleApp,
  blueLetterApp,
  blueLetterWeb,
  lifeBibleApp,
  logosBibleApp,
  oliveTreeApp,
  youVersionApp,
  weDevoteApp,
}

@lazySingleton
class BibleReaders {
  BibleReaders() {
    certified = items.filter((entry) => entry.value.isCertifiedForThisPlatform);
  }

  final items = {
    BibleReaderKey.none: const BibleReader(
      'None',
      '',
      [TargetPlatform.android, TargetPlatform.iOS],
    ),
    BibleReaderKey.andBibleApp: const BibleReader(
      'AndBible app',
      'https://read.andbible.org/BOOK.CHAPTER',
      [], // https://github.com/AndBible/and-bible/issues/3210
    ),
    BibleReaderKey.blueLetterApp: const BibleReader(
      'Blue Letter Bible app',
      'blb://BOOK/CHAPTER',
      // android: does not launch app because App info -> 'Open by default' shows '0 verified links'.
      [TargetPlatform.iOS],
      bookKeyMap: BlueLetterBookKeyMap(),
      uriVersePath: '/VERSE',
    ),
    BibleReaderKey.blueLetterWeb: const BibleReader(
      'Blue Letter Bible web',
      'https://www.blueletterbible.org/nkjv/BOOK/CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS], // all good
      bookKeyMap: BlueLetterBookKeyMap(),
      uriVersePath: '/VERSE',
    ),
    BibleReaderKey.lifeBibleApp: const BibleReader(
      'Life Bible app',
      'tecartabible://BOOK.CHAPTER', // unknown path does not work
      [],
    ),
    BibleReaderKey.logosBibleApp: const BibleReader(
      'Logos Bible app',
      'logosref:Bible.BOOK.CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS], // android: back doesn't return to bible feed
      bookKeyMap: LogosBookKeyMap(),
      uriVersePath: '.VERSE',
    ),
    BibleReaderKey.oliveTreeApp: const BibleReader(
      'Olive Tree app',
      'olivetree://bible/BOOK.CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS], // android: back doesn't return to bible feed
      bookKeyMap: OliveTreeBookKeyMap(),
      uriVersePath: '.VERSE',
    ),
    BibleReaderKey.weDevoteApp: const BibleReader(
      'WeDevote app',
      'wdbible://bible/BOOK.CHAPTER', // see https://nickperkins.dev/2022/08/02/find-every-ios-bible-app-deeplink-url-scheme/
      [TargetPlatform.iOS], // android: does not open ref
      bookKeyMap: OsisParatextBookKeyMap(),
      uriVersePath: '.VERSE',
    ),
    BibleReaderKey.youVersionApp: const BibleReader(
      'YouVersion app',
      'youversion://bible?reference=BOOK.CHAPTER', // see https://nickperkins.dev/2022/08/02/find-every-ios-bible-app-deeplink-url-scheme/
      [TargetPlatform.android, TargetPlatform.iOS], // all good
      bookKeyMap: OsisParatextBookKeyMap(),
      uriVersePath: '.VERSE',
    ),
  };
  late final Map<BibleReaderKey, BibleReader> certified;

  List<BibleReader> get certifiedList => certified.values.toList();
}
