import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_readers.dart';
import 'package:bible_feed/service/bible_readers_certified_service.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import 'bible_readers_certified_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BibleReader>()])
void main() async {
  final bibleReaders = BibleReaders(List<BibleReader>.generate(4, (_) => MockBibleReader()));
  when(bibleReaders[0].certifiedPlatforms).thenReturn([]);
  when(bibleReaders[1].certifiedPlatforms).thenReturn([TargetPlatform.android]);
  when(bibleReaders[2].certifiedPlatforms).thenReturn([TargetPlatform.iOS]);
  when(bibleReaders[3].certifiedPlatforms).thenReturn([TargetPlatform.android, TargetPlatform.iOS]);

  parameterizedTest(
    'certifiedBibleReaderList',
    [
      [
        true,
        false,
        [bibleReaders[1], bibleReaders[3]],
      ],
      [
        false,
        true,
        [bibleReaders[2], bibleReaders[3]],
      ],
    ],
    (isAndroid, isIOS, expectResult) {
      final platformService = PlatformService(isAndroid: isAndroid, isIOS: isIOS, isHapticAvailable: false);
      final testee = BibleReadersCertifiedService(platformService, bibleReaders);
      expect(testee.certifiedBibleReaderList, expectResult);
    },
  );
}
