import 'package:bible_feed/model.production/bible_reader_key.dart';
import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_reader_type.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';

void main() {
  group('static getters', () {
    test('noneBibleReader', () {
      expect(noneBibleReader.key, BibleReaderKey.none);
      expect(noneBibleReader.name, '');
      expect(noneBibleReader.uriTemplate, '');
      expect(noneBibleReader.certifiedPlatforms, []);
    });

    test('blbBibleReader', () {
      expect(blbBibleReader.key, BibleReaderKey.blueLetterApp);
      expect(blbBibleReader.name, 'name');
      expect(blbBibleReader.uriTemplate, 'scheme://uri/BOOK/CHAPTER');
      expect(blbBibleReader.certifiedPlatforms, contains(TargetPlatform.android));
      expect(blbBibleReader.certifiedPlatforms, contains(TargetPlatform.iOS));
      expect(blbBibleReader.uriVersePath, '/VERSE');
    });
  });

  group('calculated getters', () {
    test('noneBibleReader', () {
      expect(noneBibleReader.displayName, '');
      expect(noneBibleReader.isApp, false);
      expect(noneBibleReader.isNone, true);
    });

    test('blbBibleReader', () {
      expect(blbBibleReader.displayName, 'name app');
      expect(blbBibleReader.isApp, true);
      expect(blbBibleReader.isNone, false);
    });
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
