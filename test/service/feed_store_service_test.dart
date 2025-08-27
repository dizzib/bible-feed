import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/feed_store_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import '../test_data.dart';

void main() async {
  late FeedStoreService testee;
  final DateTime yesterday = DateTime.now() - const Duration(days: 1);

  initFeed(Map<String, Object> storeValues) async {
    await configureDependencies(storeValues);
    testee = sl<FeedStoreService>();
  }

  setUp(() async {
    await initFeed({
      'rl1.book': 'b1',
      'rl1.chapter': 2,
      'rl1.dateModified': yesterday.toIso8601String(),
      'rl1.isRead': true,
      'rl1.verse': 3,
    });
  });

  group('loadState', () {
    test('should load defaults if store is empty', () async {
      await initFeed({});
      final state = testee.loadState(rl1);
      expect(state.book, b0);
      expect(state.chapter, 1);
      expect(state.dateModified, null);
      expect(state.isRead, false);
      expect(state.verse, 1);
    });

    test('should load from store if store is populated', () async {
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
      await initFeed({});
      await testee.saveState(rl1, FeedState(book: b1, chapter: 2, dateModified: yesterday, isRead: true, verse: 3));
      expect(sl<SharedPreferences>().getString('rl1.book'), 'b1');
      expect(sl<SharedPreferences>().getInt('rl1.chapter'), 2);
      expect(sl<SharedPreferences>().getString('rl1.dateModified'), yesterday.toIso8601String());
      expect(sl<SharedPreferences>().getBool('rl1.isRead'), true);
      expect(sl<SharedPreferences>().getInt('rl1.verse'), 3);
    });
  });
}
