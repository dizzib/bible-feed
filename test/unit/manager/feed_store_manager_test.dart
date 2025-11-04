import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/manager/feed_store_manager.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'feed_store_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<StoreService>()])
void main() async {
  late MockStoreService mockStoreService;
  late FeedStoreManager testee;

  final DateTime yesterday = DateTime.now() - const Duration(days: 1);

  setUp(() async {
    mockStoreService = MockStoreService();
    testee = FeedStoreManager(mockStoreService);
  });

  group('loadState', () {
    test('should load defaults if store is empty', () async {
      final state = testee.loadState(rl1);
      expect(state.bookKey, b0.key);
      expect(state.chapter, 1);
      expect(state.dateModified, null);
      expect(state.isRead, false);
      expect(state.verse, 1);
    });

    test('should load from store if store is populated', () async {
      when(mockStoreService.getString('rl1.book')).thenReturn('b1');
      when(mockStoreService.getInt('rl1.chapter')).thenReturn(2);
      when(mockStoreService.getString('rl1.dateModified')).thenReturn(yesterday.toIso8601String());
      when(mockStoreService.getBool('rl1.isRead')).thenReturn(true);
      when(mockStoreService.getInt('rl1.verse')).thenReturn(3);
      final state = testee.loadState(rl1);
      expect(state.bookKey, b1.key);
      expect(state.chapter, 2);
      expect(state.dateModified, yesterday);
      expect(state.isRead, true);
      expect(state.verse, 3);
    });
  });

  group('saveState', () {
    test('should save to store', () async {
      await testee.saveState(rl1, FeedState(bookKey: b1.key, chapter: 2, dateModified: yesterday, isRead: true, verse: 3));
      verify(mockStoreService.setString('rl1.book', 'b1')).called(1);
      verify(mockStoreService.setInt('rl1.chapter', 2)).called(1);
      verify(mockStoreService.setString('rl1.dateModified', yesterday.toIso8601String())).called(1);
      verify(mockStoreService.setBool('rl1.isRead', true)).called(1);
      verify(mockStoreService.setInt('rl1.verse', 3)).called(1);
    });
  });
}
