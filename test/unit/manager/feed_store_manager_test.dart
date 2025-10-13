import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/manager/feed_store_manager.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_data.dart';
import 'feed_store_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() async {
  late MockSharedPreferences mockSharedPreferences;
  late FeedStoreManager testee;

  final DateTime yesterday = DateTime.now() - const Duration(days: 1);

  setUp(() async {
    mockSharedPreferences = MockSharedPreferences();
    testee = FeedStoreManager(mockSharedPreferences);
  });

  group('loadState', () {
    test('should load defaults if store is empty', () async {
      final state = testee.loadState(rl1);
      expect(state.book, b0);
      expect(state.chapter, 1);
      expect(state.dateModified, null);
      expect(state.isRead, false);
      expect(state.verse, 1);
    });

    test('should load from store if store is populated', () async {
      when(mockSharedPreferences.getString('rl1.book')).thenReturn('b1');
      when(mockSharedPreferences.getInt('rl1.chapter')).thenReturn(2);
      when(mockSharedPreferences.getString('rl1.dateModified')).thenReturn(yesterday.toIso8601String());
      when(mockSharedPreferences.getBool('rl1.isRead')).thenReturn(true);
      when(mockSharedPreferences.getInt('rl1.verse')).thenReturn(3);
      final state = testee.loadState(rl1);
      expect(state.book, b1);
      expect(state.chapter, 2);
      expect(state.dateModified, yesterday);
      expect(state.isRead, true);
      expect(state.verse, 3);
    });
  });

  group('saveState', () {
    test('should save to store', () async {
      await testee.saveState(rl1, FeedState(book: b1, chapter: 2, dateModified: yesterday, isRead: true, verse: 3));
      verify(mockSharedPreferences.setString('rl1.book', 'b1')).called(1);
      verify(mockSharedPreferences.setInt('rl1.chapter', 2)).called(1);
      verify(mockSharedPreferences.setString('rl1.dateModified', yesterday.toIso8601String())).called(1);
      verify(mockSharedPreferences.setBool('rl1.isRead', true)).called(1);
      verify(mockSharedPreferences.setInt('rl1.verse', 3)).called(1);
    });
  });
}
