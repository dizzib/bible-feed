import 'dart:io';

import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncher extends Mock with MockPlatformInterfaceMixin implements UrlLauncherPlatform {}

class MockFeed extends Mock implements Feed {}

void main() {
  late BibleReader fixture;
  late MockFeed mockFeed;
  late MockUrlLauncher mockUrlLauncher;
  const book = Book('gen', 'Genesis', 50);

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
    when(() => mockUrlLauncher.launchUrl(any(), any())).thenAnswer((_) async => true);
    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  test('constructor initializes properties', () {
    expect(fixture.displayName, 'Test Reader');
    expect(fixture.uriTemplate, 'https://example.com/BOOK/CHAPTER');
    expect(fixture.certifiedPlatforms, contains(TargetPlatform.android));
    expect(fixture.certifiedPlatforms, contains(TargetPlatform.iOS));
    expect(fixture.uriVersePath, '/VERSE');
  });

  group('launch', () {
    test('not in verse scope, should launch without verse path', () async {
      when(() => mockFeed.state).thenReturn(
        FeedState(book: book, chapter: 1, dateModified: null, isRead: false, verse: 1),
      );
      await fixture.launch(mockFeed);
      verify(() => mockUrlLauncher.launchUrl('https://example.com/gen/1', any())).called(1);
    });

    test('in verse scope, should launch with verse path', () async {
      when(() => mockFeed.state).thenReturn(
        FeedState(book: book, chapter: 1, dateModified: null, isRead: false, verse: 2),
      );
      await fixture.launch(mockFeed);
      verify(() => mockUrlLauncher.launchUrl('https://example.com/gen/1/2', any())).called(1);
    });
  });

  // test('isCertifiedForThisPlatform returns true for supported platform', () {
  //   bool result = false;
  //   if (Platform.isAndroid) {
  //     result = fixture.isCertifiedForThisPlatform;
  //     expect(result, true);
  //   } else if (Platform.isIOS) {
  //     result = fixture.isCertifiedForThisPlatform;
  //     expect(result, true);
  //   } else {
  //     result = fixture.isCertifiedForThisPlatform;
  //     expect(result, false);
  //   }
  // });
}
