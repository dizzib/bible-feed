import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_reader_keys.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../injectable.dart';
import '../test_data.dart';
import 'bible_reader_test.mocks.dart';

class MockUrlLauncher extends MockUrlLauncherPlatform with MockPlatformInterfaceMixin {}

@GenerateNiceMocks([MockSpec<Feed>(), MockSpec<UrlLauncherPlatform>()])
void main() {
  late MockUrlLauncher mockUrlLauncher;
  late BibleReader testee;

  setUp(() {
    mockUrlLauncher = MockUrlLauncher();
    testee = const BibleReader(BibleReaderKeys.blueLetterApp, 'Reader name', 'scheme://uri/BOOK/CHAPTER', [
      TargetPlatform.android,
      TargetPlatform.iOS,
    ], uriVersePath: '/VERSE');
    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  test('constructor: should initialise properties', () {
    expect(testee.key, BibleReaderKeys.blueLetterApp);
    expect(testee.displayName, 'Reader name');
    expect(testee.uriTemplate, 'scheme://uri/BOOK/CHAPTER');
    expect(testee.certifiedPlatforms, contains(TargetPlatform.android));
    expect(testee.certifiedPlatforms, contains(TargetPlatform.iOS));
    expect(testee.uriVersePath, '/VERSE');
  });

  group('launch', () {
    test('not in verse scope, should launch without verse path', () async {
      await testee.launch(FeedState(book: b0, verse: 1));
      verify(mockUrlLauncher.launchUrl('scheme://uri/b0/1', any)).called(1);
    });

    test('in verse scope, should launch with verse path', () async {
      await testee.launch(FeedState(book: b0, verse: 2));
      verify(mockUrlLauncher.launchUrl('scheme://uri/b0/1/2', any)).called(1);
    });

    parameterizedTest('no exception thrown, should return launchUrl return value', [true, false], (retval) async {
      when(mockUrlLauncher.launchUrl(any, any)).thenAnswer((_) async => retval);
      expect(await testee.launch(FeedState(book: b0, verse: 1)), retval);
    });

    test('PlatformException thrown, should return false', () async {
      when(mockUrlLauncher.launchUrl(any, any)).thenThrow(PlatformException);
      expect(await testee.launch(FeedState(book: b0, verse: 2)), false);
    });
  });

  group('isAvailable', () {
    test('should return true if None', () async {
      expect(await const BibleReader(BibleReaderKeys.none, 'None', '', []).isAvailable(), true);
    });

    test('should attempt to launch first feed uri if not None', () async {
      await configureDependencies();
      final mockFeed = MockFeed();
      when(mockFeed.state).thenReturn(FeedState(book: b0));
      await testee.isAvailable();
      verify(mockUrlLauncher.canLaunch(any)).called(1);
    });
  });
}
