import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/bible_reader_app_install_service.dart';
import 'package:bible_feed/service/bible_reader_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injectable.dart';
import '../test_data.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() async {
  late BibleReaderService testee;
  late MockSharedPreferences mockSharedPreferences;

  await configureDependencies();

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    testee = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), mockSharedPreferences);
  });

  Future callLaunchLinkedBibleReader(bool isRead) async {
    final state = FeedState(book: b0, isRead: isRead);
    when(() => blbMockBibleReader.launch(state)).thenAnswer((_) async => true);
    await testee.launchLinkedBibleReader(state);
    return state;
  }

  group('when not linked:', () {
    test('getter defaults', () {
      expect(testee.isLinked, false);
      expect(testee.linkedBibleReaderIndex, 0);
      expect(testee.linkedBibleReader.displayName, 'None');
    });

    test('linkedBibleReaderIndex setter should update and save to store', () {
      when(() => mockSharedPreferences.setString('linkedBibleReader', any())).thenAnswer((_) async => true);
      testee.linkedBibleReaderIndex = 1;
      verify(() => mockSharedPreferences.setString('linkedBibleReader', 'blueLetterApp')).called(1);
      expect(testee.linkedBibleReaderIndex, 1);
    });

    test('launchLinkedBibleReader if unread, should not launch', () async {
      final state = await callLaunchLinkedBibleReader(false);
      verifyNever(() => blbMockBibleReader.launch(state));
    });
  });

  group('when linked to invalid:', () {
    test('isLinked should be false', () {
      when(() => mockSharedPreferences.getString('linkedBibleReader')).thenReturn('invalid');
      testee = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), mockSharedPreferences);
      expect(testee.isLinked, false);
    });
  });

  group('when linked to BLB:', () {
    setUp(() {
      when(() => mockSharedPreferences.getString('linkedBibleReader')).thenReturn('blueLetterApp');
      testee = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), mockSharedPreferences);
    });

    test('getter defaults', () {
      expect(testee.isLinked, true);
      expect(testee.linkedBibleReader, blbMockBibleReader);
      expect(testee.linkedBibleReaderIndex, 1);
    });

    group('launchLinkedBibleReader', () {
      test('if unread, should launch', () async {
        final state = await callLaunchLinkedBibleReader(false);
        verify(() => blbMockBibleReader.launch(state)).called(1);
      });

      test('if read, should not launch', () async {
        final state = await callLaunchLinkedBibleReader(true);
        verifyNever(() => blbMockBibleReader.launch(state));
      });
    });
  });
}
