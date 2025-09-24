import 'package:bible_feed/model.production/bible_reader_key.dart';
import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_reader_type.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';

void main() {
  late BibleReader testee;

  setUp(() {
    testee = blbBibleReader;
  });

  test('constructor: should initialise properties', () {
    expect(testee.key, BibleReaderKey.blueLetterApp);
    expect(testee.name, 'name');
    expect(testee.displayName, 'name app');
    expect(testee.isApp, true);
    expect(testee.uriTemplate, 'scheme://uri/BOOK/CHAPTER');
    expect(testee.certifiedPlatforms, contains(TargetPlatform.android));
    expect(testee.certifiedPlatforms, contains(TargetPlatform.iOS));
    expect(testee.uriVersePath, '/VERSE');
  });

  parameterizedTest(
    'isCertified',
    [
      [
        [TargetPlatform.android],
        true,
        false,
        true,
      ],
      [
        [TargetPlatform.android],
        false,
        true,
        false,
      ],
      [
        [TargetPlatform.iOS],
        false,
        true,
        true,
      ],
      [
        [TargetPlatform.iOS],
        true,
        false,
        false,
      ],
    ],
    (certifiedPlatforms, isAndroid, isIOS, expectResult) {
      final platform = PlatformService(isAndroid: isAndroid, isIOS: isIOS, isHapticAvailable: false);
      final testee = BibleReader(BibleReaderKey.none, BibleReaderType.none, '', '', certifiedPlatforms);
      expect(testee.isCertified(platform), expectResult);
    },
  );
}
