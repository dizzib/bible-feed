import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/manager/bible_reader_link_manager.dart';
import 'package:bible_feed/manager/bible_readers_certified_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_data.dart';
import 'bible_reader_link_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BibleReadersCertifiedService>(), MockSpec<SharedPreferences>()])
void main() async {
  late MockBibleReadersCertifiedService mockBibleReadersCertifiedService;
  late MockSharedPreferences mockSharedPreferences;
  late BibleReaderLinkManager testee;

  setUp(() {
    mockBibleReadersCertifiedService = MockBibleReadersCertifiedService();
    mockSharedPreferences = MockSharedPreferences();
    when(mockBibleReadersCertifiedService.certifiedBibleReaderList).thenReturn([noneBibleReader, blbBibleReader]);
    testee = BibleReaderLinkManager(mockSharedPreferences, mockBibleReadersCertifiedService);
  });

  parameterizedTest(
    'constructor should load linkedBibleReader from store',
    [
      [null, false, 0, noneBibleReader],
      ['invalid', false, 0, noneBibleReader],
      ['blueLetterApp', true, 1, blbBibleReader],
    ],
    (String? bibleReaderKey, bool expectIsLinked, int expectIndex, BibleReader expectBibleReader) {
      when(mockSharedPreferences.getString('linkedBibleReader')).thenReturn(bibleReaderKey);
      testee = BibleReaderLinkManager(mockSharedPreferences, mockBibleReadersCertifiedService);
      expect(testee.isLinked, expectIsLinked);
      expect(testee.linkedBibleReader, expectBibleReader);
      expect(testee.linkedBibleReaderIndex, expectIndex);
    },
  );

  test('constructor should set linkedBibleReader to none if stored linkedBibleReader is uncertified', () {
    when(mockBibleReadersCertifiedService.certifiedBibleReaderList).thenReturn([]);
    when(mockSharedPreferences.getString('linkedBibleReader')).thenReturn('blueLetterApp');
    testee = BibleReaderLinkManager(mockSharedPreferences, mockBibleReadersCertifiedService);
    expect(testee.isLinked, false);
  });

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
