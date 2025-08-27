import 'package:bible_feed/model/book.dart';
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
  late BibleReaderService linkedTestee;
  late BibleReaderService unlinkedTestee;
  late MockSharedPreferences blbMockSharedPreferences;
  late MockSharedPreferences emptyMockSharedPreferences;

  await configureDependencies();

  setUp(() {
    blbMockSharedPreferences = MockSharedPreferences();
    emptyMockSharedPreferences = MockSharedPreferences();
    when(() => blbMockSharedPreferences.getString('linkedBibleReader')).thenReturn('blueLetterApp');
    when(() => emptyMockSharedPreferences.getString('linkedBibleReader')).thenReturn(null);
    linkedTestee = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), blbMockSharedPreferences);
    unlinkedTestee =
        BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), emptyMockSharedPreferences);
  });

  group('isLinked', () {
    test('should be false if store is empty', () {
      expect(unlinkedTestee.isLinked, false);
    });

    test('should be false if store is nonsense', () {
      final mockSharedPreferences = MockSharedPreferences();
      when(() => mockSharedPreferences.getString('linkedBibleReader')).thenReturn('nonsense');
      final testee = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), mockSharedPreferences);
      expect(testee.isLinked, false);
    });

    test('should be true if store is blb', () {
      expect(linkedTestee.isLinked, true);
    });
  });

  group('linkedBibleReader', () {
    test('should be none if not linked', () {
      expect(unlinkedTestee.linkedBibleReader.displayName, 'None');
    });

    test('should be blb if linked to blb', () {
      expect(linkedTestee.linkedBibleReader.displayName, 'Blue Letter Bible app');
    });
  });

  group('linkedBibleReaderIndex', () {
    test('get should be zero if not linked', () {
      expect(unlinkedTestee.linkedBibleReaderIndex, 0);
    });

    test('get should be 1 if linked to blb', () {
      expect(linkedTestee.linkedBibleReaderIndex, 1);
    });

    test('set should update and save to store', () {
      when(() => emptyMockSharedPreferences.setString('linkedBibleReader', any())).thenAnswer((_) async => true);
      unlinkedTestee.linkedBibleReaderIndex = 1;
      verify(() => emptyMockSharedPreferences.setString('linkedBibleReader', 'blueLetterApp')).called(1);
      expect(unlinkedTestee.linkedBibleReaderIndex, 1);
    });
  });

  group('launchLinkedBibleReader', () {
    const book = Book('gen', 'Genesis', 50);

    test('if linked and unread, should launch', () async {
      final state = FeedState(book: book, chapter: 1, isRead: false);
      when(() => blbMockBibleReader.launch(state)).thenAnswer((_) async => true);
      await linkedTestee.launchLinkedBibleReader(state);
      verify(() => blbMockBibleReader.launch(state)).called(1);
    });

    test('if not linked and unread, should not launch', () {
      final state = FeedState(book: book, chapter: 1, isRead: false);
      unlinkedTestee.launchLinkedBibleReader(state);
      verifyNever(() => blbMockBibleReader.launch(state));
    });

    test('if linked and read, should not launch', () {
      final state = FeedState(book: book, chapter: 1, isRead: true);
      linkedTestee.launchLinkedBibleReader(state);
      verifyNever(() => blbMockBibleReader.launch(state));
    });
  });
}
