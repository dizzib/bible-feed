import 'package:flutter/foundation.dart';
import 'package:dartx/dartx.dart';
import '/model/bible_reader.dart';
import 'bible_reader_book_keymap.dart';

enum BibleReaderKey {
  none,
  andBibleApp,
  blueLetterApp,
  lifeBibleApp,
  logosBibleApp,
  oliveTreeApp,
  youVersionApp,
  weDevoteApp,
}

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
      // https://github.com/AndBible/and-bible/issues/3210
      'AndBible app',
      'https://read.andbible.org/BOOK.CHAPTER',
      [],
    ),
    BibleReaderKey.blueLetterApp: const BibleReader(
      // android: does not launch app because App info -> 'Open by default' shows '0 verified links'.
      'Blue Letter Bible app',
      'blb://BOOK/CHAPTER',
      [TargetPlatform.iOS],
      BlueLetterBookKeyMap(),
    ),
    BibleReaderKey.lifeBibleApp: const BibleReader(
      'Life Bible app',
      'tecartabible://BOOK.CHAPTER', // unknown path does not work
      [],
    ),
    BibleReaderKey.logosBibleApp: const BibleReader(
      'Logos Bible app',
      'logosref:Bible.BOOK.CHAPTER',
      [TargetPlatform.iOS], // android: back doesn't return to bible feed
      LogosBookKeyMap(),
    ),
    BibleReaderKey.oliveTreeApp: const BibleReader(
      'Olive Tree app',
      'olivetree://bible/BOOK.CHAPTER',
      [TargetPlatform.iOS], // android: back doesn't return to bible feed
      OliveTreeBookKeyMap(),
    ),
    BibleReaderKey.weDevoteApp: const BibleReader(
      'WeDevote app',
      'wdbible://bible/BOOK.CHAPTER', // see https://nickperkins.dev/2022/08/02/find-every-ios-bible-app-deeplink-url-scheme/
      [TargetPlatform.iOS], // android: does not open ref
      OsisParatextBookKeyMap(),
    ),
    BibleReaderKey.youVersionApp: const BibleReader(
      'YouVersion app',
      'youversion://bible?reference=BOOK.CHAPTER', // see https://nickperkins.dev/2022/08/02/find-every-ios-bible-app-deeplink-url-scheme/
      [TargetPlatform.android, TargetPlatform.iOS],
      OsisParatextBookKeyMap(),
    ),
  };
  late final Map<BibleReaderKey, BibleReader> certified;

  List<BibleReader> get certifiedList => certified.values.toList();
}
