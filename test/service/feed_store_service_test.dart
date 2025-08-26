import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/feed_store_service.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import '../stub/book_stub.dart';
import '../stub/reading_list_stub.dart';

void main() async {
  late FeedStoreService fixture;
  final DateTime yesterday = DateTime.now() - const Duration(days: 1);

  initFeed(Map<String, Object> storeValues) async {
    await configureDependencies(storeValues);
    fixture = sl<FeedStoreService>();
  }

  setUp(() async {
    await initFeed({
      'rl2.book': 'b1',
      'rl2.chapter': 2,
      'rl2.dateModified': yesterday.toIso8601String(),
      'rl2.isRead': true,
      'rl2.verse': 7,
    });
  });

  group('loadState', () {
    test('should load defaults if store is empty', () async {
      await initFeed({});
      final state = fixture.loadState(rl2);
      expect(state.book, b0);
      expect(state.chapter, 1);
      expect(state.dateModified, null);
      expect(state.isRead, false);
      expect(state.verse, 1);
    });

    test('should load from store if store is populated', () async {
      final state = fixture.loadState(rl2);
      expect(state.book, b1);
      expect(state.chapter, 2);
      expect(state.dateModified, yesterday);
      expect(state.isRead, true);
      expect(state.verse, 7);
    });
  });

  group('saveState', () {
    test('should save to store', () async {
      await initFeed({});
      await fixture.saveState(Feed(
          rl2,
          sl<VerseScopeService>(),
          FeedState(
            book: b2,
            chapter: 3,
            dateModified: yesterday,
            isRead: true,
            verse: 5,
          )));
      expect(sl<SharedPreferences>().getString('rl2.book'), 'b2');
      expect(sl<SharedPreferences>().getInt('rl2.chapter'), 3);
      expect(sl<SharedPreferences>().getString('rl2.dateModified'), yesterday.toIso8601String());
      expect(sl<SharedPreferences>().getBool('rl2.isRead'), true);
      expect(sl<SharedPreferences>().getInt('rl2.verse'), 5);
    });
  });
}
