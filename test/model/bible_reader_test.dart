import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../injectable.dart';

class MockFeed extends Mock implements Feed {}

class MockUrlLauncher extends Mock with MockPlatformInterfaceMixin implements UrlLauncherPlatform {}

void main() {
  late BibleReader fixture;
  late MockFeed mockFeed;
  late MockUrlLauncher mockUrlLauncher;

  setUp(() {
    fixture = const BibleReader(
      'Test Reader',
      'https://example.com/BOOK/CHAPTER',
      [TargetPlatform.android, TargetPlatform.iOS],
      uriVersePath: '/VERSE',
    );
    mockFeed = MockFeed();
    mockUrlLauncher = MockUrlLauncher();
    registerFallbackValue(const LaunchOptions());
    when(() => mockUrlLauncher.canLaunch(any())).thenAnswer((_) async => true);
    when(() => mockUrlLauncher.launchUrl(any(), any())).thenAnswer((_) async => true);
    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  test('constructor: should initialise properties', () {
    expect(fixture.displayName, 'Test Reader');
    expect(fixture.uriTemplate, 'https://example.com/BOOK/CHAPTER');
    expect(fixture.certifiedPlatforms, contains(TargetPlatform.android));
    expect(fixture.certifiedPlatforms, contains(TargetPlatform.iOS));
    expect(fixture.uriVersePath, '/VERSE');
  });

  group('launch', () {
    run(bool isVerseScope, String expectedUrl) async {
      await fixture.launch(FeedState(
          book: const Book('gen', 'Genesis', 50),
          chapter: 1,
          dateModified: null,
          isRead: false,
          verse: isVerseScope ? 2 : 1));
      verify(() => mockUrlLauncher.launchUrl(expectedUrl, any())).called(1);
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
      await configureDependencies({
        'rl0.book': 'b0',
        'rl0.chapter': 1,
        'rl0.dateModified': DateTime.now().toIso8601String(),
        'rl0.isRead': true,
      });
      when(() => mockFeed.state).thenReturn(
        FeedState(book: const Book('gen', 'Genesis', 50), chapter: 1, dateModified: null, isRead: false, verse: 1),
      );
      await fixture.isAvailable();
      verify(() => mockUrlLauncher.canLaunch(any())).called(1);
    });
  });
}
