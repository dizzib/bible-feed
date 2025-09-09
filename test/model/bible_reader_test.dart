import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../injectable.dart';
import 'bible_reader_test.mocks.dart';

class MockUrlLauncher extends MockUrlLauncherPlatform with MockPlatformInterfaceMixin {}

@GenerateNiceMocks([MockSpec<Feed>(), MockSpec<UrlLauncherPlatform>()])
void main() {
  late BibleReader testee;
  late MockUrlLauncher mockUrlLauncher;

  setUp(() {
    testee = const BibleReader('Test Reader', 'https://example.com/BOOK/CHAPTER', [
      TargetPlatform.android,
      TargetPlatform.iOS,
    ], uriVersePath: '/VERSE');
    mockUrlLauncher = MockUrlLauncher();
    when(mockUrlLauncher.canLaunch(any)).thenAnswer((_) async => true);
    when(mockUrlLauncher.launchUrl(any, any)).thenAnswer((_) async => true);
    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  test('constructor: should initialise properties', () {
    expect(testee.displayName, 'Test Reader');
    expect(testee.uriTemplate, 'https://example.com/BOOK/CHAPTER');
    expect(testee.certifiedPlatforms, contains(TargetPlatform.android));
    expect(testee.certifiedPlatforms, contains(TargetPlatform.iOS));
    expect(testee.uriVersePath, '/VERSE');
  });

  group('launch', () {
    run(bool isVerseScope, String expectedUrl) async {
      await testee.launch(
        FeedState(
          book: const Book('gen', 'Genesis', 50),
          chapter: 1,
          dateModified: null,
          isRead: false,
          verse: isVerseScope ? 2 : 1,
        ),
      );
      verify(mockUrlLauncher.launchUrl(expectedUrl, any)).called(1);
    }

    test('not in verse scope, should launch without verse path', () async {
      await run(false, 'https://example.com/gen/1');
    });

    test('in verse scope, should launch with verse path', () async {
      await run(true, 'https://example.com/gen/1/2');
    });
  });

  group('isAvailable', () {
    test('should return true if None', () async {
      expect(await const BibleReader('None', '', []).isAvailable(), true);
    });

    test('should attempt to launch first feed uri if not None', () async {
      await configureDependencies();
      final mockFeed = MockFeed();
      when(mockFeed.state).thenReturn(
        FeedState(book: const Book('gen', 'Genesis', 50), chapter: 1, dateModified: null, isRead: false, verse: 1),
      );
      await testee.isAvailable();
      verify(mockUrlLauncher.canLaunch(any)).called(1);
    });
  });
}
