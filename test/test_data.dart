import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_readers.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/reading_list.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mocktail/mocktail.dart';

const b0 = Book('b0', 'Book 0', 1);
const b1 = Book('b1', 'Book 1', 3);
var rl0 = ReadingList('rl0', 'Reading List 0', const [b0]);
var rl1 = ReadingList('rl1', 'Reading List 1', const [b0, b1]);

@test
@LazySingleton(as: ReadingLists)
class TestReadingLists extends ReadingLists {
  @override
  final items = [rl0, rl1];
}

@test
@LazySingleton(as: PlatformService)
class TestPlatformService extends PlatformService {
  @override
  bool get isAndroid => false;

  @override
  bool get isIOS => true;
}

class MockBibleReader extends Mock implements BibleReader {}

var blbMockBibleReader = MockBibleReader();

@test
@LazySingleton(as: BibleReaders)
class TestBibleReaders extends BibleReaders {
  TestBibleReaders() {
    when(() => blbMockBibleReader.certifiedPlatforms).thenReturn([TargetPlatform.iOS]);
    when(() => blbMockBibleReader.displayName).thenReturn('Blue Letter Bible app');
    when(() => blbMockBibleReader.isCertifiedForThisPlatform).thenReturn(true);
    when(() => blbMockBibleReader.uriTemplate).thenReturn('blb://BOOK/CHAPTER');
    when(() => blbMockBibleReader.uriVersePath).thenReturn('/VERSE');
  }

  @override
  get items => {
        BibleReaderKey.none: const BibleReader('None', '', [TargetPlatform.android, TargetPlatform.iOS]),
        BibleReaderKey.blueLetterApp: blbMockBibleReader,
      };
}
