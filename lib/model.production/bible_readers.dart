import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/model/bible_reader.dart';
import '/model/bible_reader_key.dart';
import '/model/bible_reader_types.dart';
import '/model/bible_readers.dart' as base;
import 'book_key_externaliser.dart';

@immutable
@LazySingleton(as: base.BibleReaders)
class BibleReaders extends base.BibleReaders {
  const BibleReaders()
    : super(const [
        BibleReader(BibleReaderKey.none, BibleReaderTypes.none, 'None', '', [
          TargetPlatform.android,
          TargetPlatform.iOS,
        ]),
        // Deep links not working: https://github.com/AndBible/and-bible/issues/3210
        BibleReader(
          BibleReaderKey.andBibleApp,
          BibleReaderTypes.app,
          'AndBible',
          'https://read.andbible.org/BOOK.CHAPTER',
          [],
        ),
        BibleReader(
          BibleReaderKey.blueLetterApp,
          BibleReaderTypes.app,
          'Blue Letter Bible',
          'blb://BOOK/CHAPTER',
          [TargetPlatform.iOS], // android has Open by default -> '0 verified links' and does not open!?
          bookKeyExternaliser: BookKeyExternaliser.blueLetter,
          uriVersePath: '/VERSE',
        ),
        BibleReader(
          BibleReaderKey.blueLetterWeb,
          BibleReaderTypes.web,
          'Blue Letter Bible',
          'https://www.blueletterbible.org/nkjv/BOOK/CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.blueLetter,
          uriVersePath: '/VERSE',
        ),
        BibleReader(
          BibleReaderKey.lifeBibleApp,
          BibleReaderTypes.app,
          'Life Bible',
          'tecartabible://BOOK.CHAPTER',
          [],
        ),
        BibleReader(
          BibleReaderKey.logosBibleApp,
          BibleReaderTypes.app,
          'Logos Bible',
          'logosref:Bible.BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.logos,
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKey.oliveTreeApp,
          BibleReaderTypes.app,
          'Olive Tree',
          'olivetree://bible/BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.oliveTree,
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKey.weDevoteApp,
          BibleReaderTypes.app,
          'WeDevote',
          'wdbible://bible/BOOK.CHAPTER',
          [TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.osisParatext,
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKey.youVersionApp,
          BibleReaderTypes.app,
          'YouVersion',
          'youversion://bible?reference=BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyExternaliser: BookKeyExternaliser.osisParatext,
          uriVersePath: '.VERSE',
        ),
      ]);
}
