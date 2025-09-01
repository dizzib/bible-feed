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

  group('when not linked:', () {
    setUp(() {
      when(() => mockSharedPreferences.getString('linkedBibleReader')).thenReturn(null);
    });

    test('isLinked should be false', () {
      expect(testee.isLinked, false);
    });

    test('linkedBibleReader should be none', () {
      expect(testee.linkedBibleReader.displayName, 'None');
    });

    group('linkedBibleReaderIndex', () {
      test('getter should be zero', () {
        expect(testee.linkedBibleReaderIndex, 0);
      });

      test('setter should update and save to store', () {
        when(() => mockSharedPreferences.setString('linkedBibleReader', any())).thenAnswer((_) async => true);
        testee.linkedBibleReaderIndex = 1;
        verify(() => mockSharedPreferences.setString('linkedBibleReader', 'blueLetterApp')).called(1);
        expect(testee.linkedBibleReaderIndex, 1);
      });
    });

    test('launchLinkedBibleReader if unread, should not launch', () async {
      final state = FeedState(book: b0, chapter: 1, isRead: false);
      await testee.launchLinkedBibleReader(state);
      verifyNever(() => blbMockBibleReader.launch(state));
    });
  });

  group('when linked to invalid:', () {
    setUp(() {
      when(() => mockSharedPreferences.getString('linkedBibleReader')).thenReturn('invalid');
    });

    test('should be false if store is nonsense', () {
      expect(testee.isLinked, false);
    });
  });

  group('when linked to BLB:', () {
    setUp(() {
      when(() => mockSharedPreferences.getString('linkedBibleReader')).thenReturn('blueLetterApp');
      testee = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), mockSharedPreferences);
    });

    test('linkedBibleReader should be blbMockBibleReader', () {
      expect(testee.linkedBibleReader, blbMockBibleReader);
    });

    test('linkedBibleReaderIndex should be 1', () {
      expect(testee.linkedBibleReaderIndex, 1);
    });

    group('launchLinkedBibleReader', () {
      test('if unread, should launch', () async {
        final state = FeedState(book: b0, chapter: 1, isRead: false);
        when(() => blbMockBibleReader.launch(state)).thenAnswer((_) async => true);
        await testee.launchLinkedBibleReader(state);
        verify(() => blbMockBibleReader.launch(state)).called(1);
      });

      test('if read, should not launch', () async {
        final state = FeedState(book: b0, chapter: 1, isRead: true);
        await testee.launchLinkedBibleReader(state);
        verifyNever(() => blbMockBibleReader.launch(state));
      });
    });
  });
}
