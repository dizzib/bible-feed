import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'bible_reader.dart';
import 'bible_reader_book_keymap.dart';
import 'bible_reader_keys.dart';
import 'bible_reader_types.dart';
import 'bible_readers.dart';

@immutable
@LazySingleton(as: BibleReaders)
class ProductionBibleReaders extends BibleReaders {
  const ProductionBibleReaders()
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
          bookKeyMap: BibleReaderBookKeyMap.blueLetter,
          uriVersePath: '/VERSE',
        ),
        BibleReader(
          BibleReaderKeys.blueLetterWeb,
          BibleReaderTypes.web,
          'Blue Letter Bible',
          'https://www.blueletterbible.org/nkjv/BOOK/CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyMap: BibleReaderBookKeyMap.blueLetter,
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
          bookKeyMap: BibleReaderBookKeyMap.logos,
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKeys.oliveTreeApp,
          BibleReaderTypes.app,
          'Olive Tree',
          'olivetree://bible/BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyMap: BibleReaderBookKeyMap.oliveTree,
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKeys.weDevoteApp,
          BibleReaderTypes.app,
          'WeDevote',
          'wdbible://bible/BOOK.CHAPTER',
          [TargetPlatform.iOS],
          bookKeyMap: BibleReaderBookKeyMap.osisParatext,
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKeys.youVersionApp,
          BibleReaderTypes.app,
          'YouVersion',
          'youversion://bible?reference=BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyMap: BibleReaderBookKeyMap.osisParatext,
          uriVersePath: '.VERSE',
        ),
      ]);
}
