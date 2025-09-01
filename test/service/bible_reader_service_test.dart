import 'package:bible_feed/model/bible_reader.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:bible_feed/model/bible_readers.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/bible_reader_app_install_service.dart';
import 'package:bible_feed/service/bible_reader_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injectable.dart';
import '../test_data.dart';

class MockBibleReader extends Mock implements BibleReader {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

var noneBibleReader = const BibleReader('None', '', [TargetPlatform.android, TargetPlatform.iOS]);
var mockBibleReader = MockBibleReader();

class TestBibleReaders extends BibleReaders {
  TestBibleReaders() {
    when(() => mockBibleReader.certifiedPlatforms).thenReturn([TargetPlatform.iOS]);
    when(() => mockBibleReader.displayName).thenReturn('Blue Letter Bible app');
    when(() => mockBibleReader.isCertifiedForThisPlatform).thenReturn(true);
    when(() => mockBibleReader.uriTemplate).thenReturn('blb://BOOK/CHAPTER');
    when(() => mockBibleReader.uriVersePath).thenReturn('/VERSE');
  }

  @override
  get items => {BibleReaderKey.none: noneBibleReader, BibleReaderKey.blueLetterApp: mockBibleReader};
}

void main() async {
  await configureDependencies();

  late MockSharedPreferences mockSharedPreferences;
  late BibleReaderService testee;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    testee = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), mockSharedPreferences);
  });

  parameterizedTest(
    'property getters',
    [
      [null, false, 0, noneBibleReader],
      ['invalid', false, 0, noneBibleReader],
      ['blueLetterApp', true, 1, mockBibleReader],
    ],
    (String? bibleReaderKey, bool expectIsLinked, int expectIndex, BibleReader expectBibleReader) {
      when(() => mockSharedPreferences.getString('linkedBibleReader')).thenReturn(bibleReaderKey);
      testee = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), mockSharedPreferences);
      expect(testee.isLinked, expectIsLinked);
      expect(testee.linkedBibleReader, expectBibleReader);
      expect(testee.linkedBibleReaderIndex, expectIndex);
    },
  );

  test('linkedBibleReaderIndex setter should update and save to store', () {
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
    testee.linkedBibleReaderIndex = 1;
    verify(() => mockSharedPreferences.setString('linkedBibleReader', 'blueLetterApp')).called(1);
    expect(testee.linkedBibleReaderIndex, 1);
  });

  void verifyLaunchCalled(FeedState state) {
    verify(() => mockBibleReader.launch(state)).called(1);
  }

  void verifyLaunchNotCalled(FeedState state) {
    verifyNever(() => mockBibleReader.launch(state));
  }

  parameterizedTest(
    'launchLinkedBibleReader',
    [
      [null, false, verifyLaunchNotCalled],
      ['blueLetterApp', true, verifyLaunchNotCalled],
      ['blueLetterApp', false, verifyLaunchCalled, true],
      ['blueLetterApp', false, verifyLaunchCalled, false],
    ],
    (String? bibleReaderKey, bool isRead, Function verifyLaunch, [bool ok = true]) async {
      when(() => mockSharedPreferences.getString('linkedBibleReader')).thenReturn(bibleReaderKey);
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
      testee = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), mockSharedPreferences);
      final state = FeedState(book: b0, isRead: isRead);
      when(() => mockBibleReader.launch(state)).thenAnswer((_) async => ok);
      await testee.launchLinkedBibleReader(state);
      verifyLaunch(state);
      if (!ok) verify(() => mockSharedPreferences.setString('linkedBibleReader', 'none')).called(1);
    },
  );
}
