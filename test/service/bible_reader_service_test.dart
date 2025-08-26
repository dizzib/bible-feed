import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/bible_reader_app_install_service.dart';
import 'package:bible_feed/service/bible_reader_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injectable.dart';
import '../test_data.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late BibleReaderService linkedFixture;
  late BibleReaderService unlinkedFixture;
  late MockSharedPreferences blbMockSharedPreferences;
  late MockSharedPreferences emptyMockSharedPreferences;

  setUp(() async {
    await configureDependencies();
    blbMockSharedPreferences = MockSharedPreferences();
    emptyMockSharedPreferences = MockSharedPreferences();
    when(() => blbMockSharedPreferences.getString('linkedBibleReader')).thenReturn('blueLetterApp');
    when(() => emptyMockSharedPreferences.getString('linkedBibleReader')).thenReturn(null);
    linkedFixture = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), blbMockSharedPreferences);
    unlinkedFixture =
        BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), emptyMockSharedPreferences);
  });

  group('isLinked', () {
    test('should be false if store is empty', () {
      expect(unlinkedFixture.isLinked, false);
    });

    test('should be false if store is nonsense', () {
      final mockSharedPreferences = MockSharedPreferences();
      when(() => mockSharedPreferences.getString('linkedBibleReader')).thenReturn('nonsense');
      final fixture = BibleReaderService(BibleReaderAppInstallService(), TestBibleReaders(), mockSharedPreferences);
      expect(fixture.isLinked, false);
    });

    test('should be true if store is blb', () {
      expect(linkedFixture.isLinked, true);
    });
  });

  group('linkedBibleReader', () {
    test('should be none if not linked', () {
      expect(unlinkedFixture.linkedBibleReader.displayName, 'None');
    });

    test('should be blb if linked to blb', () {
      expect(linkedFixture.linkedBibleReader.displayName, 'Blue Letter Bible app');
    });
  });

  group('linkedBibleReaderIndex', () {
    test('get should be zero if not linked', () {
      expect(unlinkedFixture.linkedBibleReaderIndex, 0);
    });

    test('get should be 1 if linked to blb', () {
      expect(linkedFixture.linkedBibleReaderIndex, 1);
    });

    test('set should update and save to store', () {
      WidgetsFlutterBinding.ensureInitialized();
      when(() => emptyMockSharedPreferences.setString('linkedBibleReader', any())).thenAnswer((_) async => true);
      unlinkedFixture.linkedBibleReaderIndex = 1;
      verify(() => emptyMockSharedPreferences.setString('linkedBibleReader', 'blueLetterApp')).called(1);
      expect(unlinkedFixture.linkedBibleReaderIndex, 1);
    });
  });

  group('launchLinkedBibleReader', () {
    const book = Book('gen', 'Genesis', 50);

    test('if linked and unread, should launch', () async {
      final state = FeedState(book: book, chapter: 1, isRead: false);
      when(() => blbMockBibleReader.launch(state)).thenAnswer((_) async => true);
      await linkedFixture.launchLinkedBibleReader(state);
      verify(() => blbMockBibleReader.launch(state)).called(1);
    });

    test('if not linked and unread, should not launch', () {
      final state = FeedState(book: book, chapter: 1, isRead: false);
      unlinkedFixture.launchLinkedBibleReader(state);
      verifyNever(() => blbMockBibleReader.launch(state));
    });

    test('if linked and read, should not launch', () {
      final state = FeedState(book: book, chapter: 1, isRead: true);
      linkedFixture.launchLinkedBibleReader(state);
      verifyNever(() => blbMockBibleReader.launch(state));
    });
  });
}
