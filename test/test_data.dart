import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_readers.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mocktail/mocktail.dart';

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
        BibleReaderKey.none: const BibleReader(
          'None',
          '',
          [TargetPlatform.android, TargetPlatform.iOS],
        ),
        BibleReaderKey.blueLetterApp: blbMockBibleReader,
      };
}
