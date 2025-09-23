import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model.production/bible_reader_key.dart';
import 'package:bible_feed/model/bible_reader_type.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../injectable.dart';
import '../test_data.dart';
import 'bible_reader_test.mocks.dart';

class MockUrlLauncher extends MockUrlLauncherPlatform with MockPlatformInterfaceMixin {}

@GenerateNiceMocks([MockSpec<Feed>(), MockSpec<UrlLauncherPlatform>()])
void main() {
  late MockUrlLauncher mockUrlLauncher;
  late BibleReader testee;

  setUp(() {
    mockUrlLauncher = MockUrlLauncher();
    testee = const BibleReader(
      BibleReaderKey.blueLetterApp,
      BibleReaderType.app,
      'Reader name',
      'scheme://uri/BOOK/CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS],
      uriVersePath: '/VERSE',
    );
    UrlLauncherPlatform.instance = mockUrlLauncher;
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
      expect(await const BibleReader(BibleReaderKey.none, BibleReaderType.none, 'None', '', []).isAvailable(), true);
    });

    test('should attempt to launch first feed uri if not None', () async {
      await configureDependencies();
      final mockFeed = MockFeed();
      when(mockFeed.state).thenReturn(FeedState(book: b0));
      await testee.isAvailable();
      verify(mockUrlLauncher.canLaunch(any)).called(1);
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
        await testee.launch(FeedState(book: b0, verse: verse));
        verify(mockUrlLauncher.launchUrl(expectLaunchUri, any)).called(1);
      },
    );

    parameterizedTest('should return whatever launchUrl returns', [true, false], (retval) async {
      when(mockUrlLauncher.launchUrl(any, any)).thenAnswer((_) async => retval);
      expect(await testee.launch(FeedState(book: b0, verse: 1)), retval);
    });
  });
}
