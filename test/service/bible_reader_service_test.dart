import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_reader_keys.dart';
import 'package:bible_feed/model/bible_readers.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/bible_reader_app_install_service.dart';
import 'package:bible_feed/service/bible_reader_service.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:bible_feed/service/result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injectable.dart';
import '../test_data.dart';
import 'bible_reader_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BibleReader>(), MockSpec<PlatformService>(), MockSpec<SharedPreferences>()])
void main() async {
  await configureDependencies();

  final mockPlatformService = MockPlatformService();
  final bibleReaders = BibleReaders([MockBibleReader(), MockBibleReader()]);
  when(bibleReaders[0].isCertified(mockPlatformService)).thenReturn(true);
  when(bibleReaders[1].isCertified(mockPlatformService)).thenReturn(true);
  when(bibleReaders[1].key).thenReturn(BibleReaderKeys.blueLetterApp);

  late MockSharedPreferences mockSharedPreferences;
  late BibleReaderService testee;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    testee = BibleReaderService(
      BibleReaderAppInstallService(),
      mockSharedPreferences,
      mockPlatformService,
      bibleReaders,
    );
  });

  parameterizedTest(
    'property getters',
    [
      [null, false, 0, bibleReaders[0]],
      ['invalid', false, 0, bibleReaders[0]],
      ['blueLetterApp', true, 1, bibleReaders[1]],
    ],
    (String? bibleReaderKey, bool expectIsLinked, int expectIndex, BibleReader expectBibleReader) {
      when(mockSharedPreferences.getString('linkedBibleReader')).thenReturn(bibleReaderKey);
      testee = BibleReaderService(
        BibleReaderAppInstallService(),
        mockSharedPreferences,
        mockPlatformService,
        bibleReaders,
      );
      expect(testee.isLinked, expectIsLinked);
      expect(testee.linkedBibleReader, expectBibleReader);
      expect(testee.linkedBibleReaderIndex, expectIndex);
    },
  );

  test('linkedBibleReaderIndex setter should update and save to store', () {
    testee.linkedBibleReaderIndex = 1;
    verify(mockSharedPreferences.setString('linkedBibleReader', 'blueLetterApp')).called(1);
    expect(testee.linkedBibleReaderIndex, 1);
  });

  parameterizedTest(
    'launchLinkedBibleReader',
    [
      [null, false, false, Success()],
      ['blueLetterApp', true, false, Success()],
      ['blueLetterApp', false, true, Success(), true],
      ['blueLetterApp', false, true, Failure(), false],
    ],
    (String? bibleReaderKey, bool isRead, bool expectLaunch, Result expectResult, [bool launchOk = true]) async {
      // arrange
      final state = FeedState(book: b0, isRead: isRead);
      when(bibleReaders[1].launch(state)).thenAnswer((_) async => launchOk);
      when(mockSharedPreferences.getString('linkedBibleReader')).thenReturn(bibleReaderKey);

      // act
      testee = BibleReaderService(
        BibleReaderAppInstallService(),
        mockSharedPreferences,
        mockPlatformService,
        bibleReaders,
      );
      final result = await testee.launchLinkedBibleReader(state);

      // assert
      if (expectLaunch) {
        verify(bibleReaders[1].launch(state)).called(1);
      } else {
        verifyNever(bibleReaders[1].launch(state));
      }
      expect(result.runtimeType, expectResult.runtimeType);
    },
  );

  test('launchLinkedBibleReader should return Failure on PlatformException', () async {
    testee.linkedBibleReaderIndex = 1;
    var state = FeedState(book: b1, isRead: false);
    when(bibleReaders[1].launch(state)).thenThrow(PlatformException(code: 'code'));
    expect((await testee.launchLinkedBibleReader(state)).runtimeType, Failure);
  });
}
