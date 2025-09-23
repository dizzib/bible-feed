import 'package:bible_feed/model.production/bible_reader_key.dart';
import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_reader_type.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:bible_feed/service/url_launch_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';
import 'bible_reader_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Feed>(), MockSpec<UrlLaunchService>()])
void main() {
  late MockUrlLaunchService mockUrlLaunchService;
  late BibleReader testee;

  setUp(() {
    mockUrlLaunchService = MockUrlLaunchService();
    testee = const BibleReader(
      BibleReaderKey.blueLetterApp,
      BibleReaderType.app,
      'Reader name',
      'scheme://uri/BOOK/CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS],
      uriVersePath: '/VERSE',
    );
  });

  test('constructor: should initialise properties', () {
    expect(testee.key, BibleReaderKey.blueLetterApp);
    expect(testee.name, 'Reader name');
    expect(testee.displayName, 'Reader name app');
    expect(testee.isApp, true);
    expect(testee.uriTemplate, 'scheme://uri/BOOK/CHAPTER');
    expect(testee.certifiedPlatforms, contains(TargetPlatform.android));
    expect(testee.certifiedPlatforms, contains(TargetPlatform.iOS));
    expect(testee.uriVersePath, '/VERSE');
  });

  group('isAvailable', () {
    test('should return true if None', () async {
      expect(
        await const BibleReader(
          BibleReaderKey.none,
          BibleReaderType.none,
          'None',
          '',
          [],
        ).isAvailable(mockUrlLaunchService),
        true,
      );
    });

    test('should attempt to launch matthew 1 if not None', () async {
      await testee.isAvailable(mockUrlLaunchService);
      verify(mockUrlLaunchService.canLaunchUrl(Uri.parse('scheme://uri/mat/1'))).called(1);
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

  group('launch', () {
    parameterizedTest(
      'should call launchUrl with correct uri',
      [
        [1, 'scheme://uri/b0/1'],
        [2, 'scheme://uri/b0/1/2'],
      ],
      (verse, expectLaunchUri) async {
        await testee.launch(mockUrlLaunchService, FeedState(book: b0, verse: verse));
        verify(mockUrlLaunchService.launchUrl(Uri.parse(expectLaunchUri))).called(1);
      },
    );

    parameterizedTest('should return whatever launchUrl returns', [true, false], (retval) async {
      when(mockUrlLaunchService.launchUrl(any)).thenAnswer((_) async => retval);
      expect(await testee.launch(mockUrlLaunchService, FeedState(book: b0, verse: 1)), retval);
    });
  });
}
