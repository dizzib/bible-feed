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

  var noneMockBibleReader = MockBibleReader();
  var blbMockBibleReader = MockBibleReader();

  final bibleReaders = [noneMockBibleReader, blbMockBibleReader];
  late MockSharedPreferences mockSharedPreferences;
  late BibleReaderService testee;

  setUp(() {
    when(noneMockBibleReader.isCertifiedForThisPlatform).thenReturn(true);
    when(blbMockBibleReader.key).thenReturn(BibleReaderKey.blueLetterApp);
    when(blbMockBibleReader.isCertifiedForThisPlatform).thenReturn(true);
    when(blbMockBibleReader.uriTemplate).thenReturn('blb://BOOK/CHAPTER');
    when(blbMockBibleReader.uriVersePath).thenReturn('/VERSE');
    mockSharedPreferences = MockSharedPreferences();
    testee = BibleReaderService(BibleReaderAppInstallService(), bibleReaders, mockSharedPreferences);
  });

  parameterizedTest(
    'property getters',
    [
      [null, false, 0, noneMockBibleReader],
      ['invalid', false, 0, noneMockBibleReader],
      ['blueLetterApp', true, 1, blbMockBibleReader],
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
    when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
    testee.linkedBibleReaderIndex = 1;
    verify(mockSharedPreferences.setString('linkedBibleReader', 'blueLetterApp')).called(1);
    expect(testee.linkedBibleReaderIndex, 1);
  });

  void verifyLaunchCalled(FeedState state) {
    verify(blbMockBibleReader.launch(state)).called(1);
  }

  void verifyLaunchNotCalled(FeedState state) {
    verifyNever(blbMockBibleReader.launch(state));
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
      when(blbMockBibleReader.launch(state)).thenAnswer((_) async => ok);
      when(mockSharedPreferences.getString('linkedBibleReader')).thenReturn(bibleReaderKey);
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      testee = BibleReaderService(BibleReaderAppInstallService(), bibleReaders, mockSharedPreferences);
      await testee.launchLinkedBibleReader(state);
      verifyLaunch(state);
      if (!ok) verify(mockSharedPreferences.setString('linkedBibleReader', 'none')).called(1);
    },
  );
}
