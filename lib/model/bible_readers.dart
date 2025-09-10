import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'bible_reader.dart';
import 'bible_reader_book_keymap.dart';

enum BibleReaderKeys {
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

// base class, for unit tests
@immutable
class BibleReaders extends Iterable<BibleReader> {
  const BibleReaders(this._items);

  final List<BibleReader> _items;

  @override
  Iterator<BibleReader> get iterator => _items.iterator;

  BibleReader operator [](int i) => _items[i];
}

@LazySingleton(as: BibleReaders)
@immutable
class ProdBibleReaders extends BibleReaders {
  const ProdBibleReaders()
    : super(const [
        BibleReader(BibleReaderKeys.none, 'None', '', [TargetPlatform.android, TargetPlatform.iOS]),
        BibleReader(BibleReaderKeys.andBibleApp, 'AndBible app', 'https://read.andbible.org/BOOK.CHAPTER', []),
        BibleReader(
          BibleReaderKeys.blueLetterApp,
          'Blue Letter Bible app',
          'blb://BOOK/CHAPTER',
          [TargetPlatform.iOS],
          bookKeyMap: BlueLetterBookKeyMap(),
          uriVersePath: '/VERSE',
        ),
        BibleReader(
          BibleReaderKeys.blueLetterWeb,
          'Blue Letter Bible web',
          'https://www.blueletterbible.org/nkjv/BOOK/CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyMap: BlueLetterBookKeyMap(),
          uriVersePath: '/VERSE',
        ),
        BibleReader(BibleReaderKeys.lifeBibleApp, 'Life Bible app', 'tecartabible://BOOK.CHAPTER', []),
        BibleReader(
          BibleReaderKeys.logosBibleApp,
          'Logos Bible app',
          'logosref:Bible.BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyMap: LogosBookKeyMap(),
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKeys.oliveTreeApp,
          'Olive Tree app',
          'olivetree://bible/BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyMap: OliveTreeBookKeyMap(),
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKeys.weDevoteApp,
          'WeDevote app',
          'wdbible://bible/BOOK.CHAPTER',
          [TargetPlatform.iOS],
          bookKeyMap: OsisParatextBookKeyMap(),
          uriVersePath: '.VERSE',
        ),
        BibleReader(
          BibleReaderKeys.youVersionApp,
          'YouVersion app',
          'youversion://bible?reference=BOOK.CHAPTER',
          [TargetPlatform.android, TargetPlatform.iOS],
          bookKeyMap: OsisParatextBookKeyMap(),
          uriVersePath: '.VERSE',
        ),
      ]);
}
