import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/model/bible_reader.dart';
import '/model/bible_reader_keys.dart';
import '/model/bible_reader_types.dart';
import '/model/bible_readers.dart' as base;
import 'book_key_externaliser.dart';

@immutable
@LazySingleton(as: base.BibleReaders)
class BibleReaders extends base.BibleReaders {
  const BibleReaders()
    : super(const [
        BibleReader(BibleReaderKeys.none, BibleReaderTypes.none, 'None', '', [
          TargetPlatform.android,
          TargetPlatform.iOS,
        ]),
        // Deep links not working: https://github.com/AndBible/and-bible/issues/3210
        BibleReader(
          BibleReaderKeys.andBibleApp,
          BibleReaderTypes.app,
          'AndBible',
          'https://read.andbible.org/BOOK.CHAPTER',
          [],
        ),
        BibleReader(
          BibleReaderKeys.blueLetterApp,
          BibleReaderTypes.app,
          'Blue Letter Bible',
          'blb://BOOK/CHAPTER',
          [TargetPlatform.iOS], // android has Open by default -> '0 verified links' and does not open!?
          bookKeyExternaliser: BookKeyExternaliser.blueLetter,
          uriVersePath: '/VERSE',
        ),
        BibleReader(
          BibleReaderKeys.blueLetterWeb,
          BibleReaderTypes.web,
          'Blue Letter Bible',
          'https://www.blueletterbible.org/nkjv/BOOK/CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.blueLetter,
          uriVersePath: '/VERSE',
        ),
        BibleReader(
          BibleReaderKeys.lifeBibleApp,
          BibleReaderTypes.app,
          'Life Bible',
          'tecartabible://BOOK.CHAPTER',
          [],
        ),
        BibleReader(
          BibleReaderKeys.logosBibleApp,
          BibleReaderTypes.app,
          'Logos Bible',
          'logosref:Bible.BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.logos,
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKeys.oliveTreeApp,
          BibleReaderTypes.app,
          'Olive Tree',
          'olivetree://bible/BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.oliveTree,
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKeys.weDevoteApp,
          BibleReaderTypes.app,
          'WeDevote',
          'wdbible://bible/BOOK.CHAPTER',
          [TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.osisParatext,
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKeys.youVersionApp,
          BibleReaderTypes.app,
          'YouVersion',
          'youversion://bible?reference=BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.osisParatext,
          uriVersePath: '.VERSE',
        ),
      ]);
}
