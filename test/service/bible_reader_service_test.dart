import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_readers.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/bible_reader_app_install_service.dart';
import 'package:bible_feed/service/bible_reader_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injectable.dart';
import '../test_data.dart';
import 'bible_reader_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BibleReader>(), MockSpec<SharedPreferences>()])
void main() async {
  await configureDependencies();

  final bibleReaders = [MockBibleReader(), MockBibleReader()];
  when(bibleReaders[0].isCertifiedForThisPlatform).thenReturn(true);
  when(bibleReaders[1].isCertifiedForThisPlatform).thenReturn(true);
  when(bibleReaders[1].key).thenReturn(BibleReaderKey.blueLetterApp);

  late MockSharedPreferences mockSharedPreferences;
  late BibleReaderService testee;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    testee = BibleReaderService(BibleReaderAppInstallService(), bibleReaders, mockSharedPreferences);
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
      testee = BibleReaderService(BibleReaderAppInstallService(), bibleReaders, mockSharedPreferences);
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

  void verifyLaunchCalled(FeedState state) {
    verify(bibleReaders[1].launch(state)).called(1);
  }

  void verifyLaunchNotCalled(FeedState state) {
    verifyNever(bibleReaders[1].launch(state));
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
      final state = FeedState(book: b0, isRead: isRead);
      when(mockSharedPreferences.getString('linkedBibleReader')).thenReturn(bibleReaderKey);
      testee = BibleReaderService(BibleReaderAppInstallService(), bibleReaders, mockSharedPreferences);
      await testee.launchLinkedBibleReader(state);
      verifyLaunch(state);
      if (!ok) verify(mockSharedPreferences.setString('linkedBibleReader', 'none')).called(1);
    },
  );
}
