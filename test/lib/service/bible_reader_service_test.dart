import 'package:bible_feed/model.production/bible_reader_key.dart';
import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_readers.dart';
import 'package:bible_feed/service/bible_reader_service.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bible_reader_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BibleReader>(),
  MockSpec<PlatformService>(),
  MockSpec<SharedPreferences>(),
])
void main() async {
  final mockPlatformService = MockPlatformService();
  final bibleReaders = BibleReaders([MockBibleReader(), MockBibleReader()]);
  when(bibleReaders[0].isCertified(mockPlatformService)).thenReturn(true);
  when(bibleReaders[1].isCertified(mockPlatformService)).thenReturn(true);
  when(bibleReaders[1].key).thenReturn(BibleReaderKey.blueLetterApp);

  late MockSharedPreferences mockSharedPreferences;
  late BibleReaderService testee;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    testee = BibleReaderService(mockSharedPreferences, mockPlatformService, bibleReaders);
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
      testee = BibleReaderService(mockSharedPreferences, mockPlatformService, bibleReaders);
      expect(testee.certifiedBibleReaderList, bibleReaders);
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

  test('unlinkBibleReader should set to none and save to store', () {
    testee.linkedBibleReaderIndex = 1;
    testee.unlinkBibleReader();
    verify(mockSharedPreferences.setString('linkedBibleReader', 'none')).called(1);
    expect(testee.isLinked, false);
  });
}
