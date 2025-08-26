import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/service/feed_store_service.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import '../stub/reading_list_stub.dart';

void main() async {
  late Feeds feeds;

  setUp(() async {
    await configureDependencies({
      'rl0.book': 'b0',
      'rl0.chapter': 1,
      'rl0.dateModified': DateTime.now().toIso8601String(),
      'rl0.isRead': true,
      'rl1.book': 'b1',
      'rl1.chapter': 1,
      'rl1.dateModified': DateTime.now().toIso8601String(),
      'rl1.isRead': false,
    });
    feeds = Feeds(
      di<FeedStoreService>(),
      di<VerseScopeService>(),
      di<ReadingLists>(),
    );
  });

  test('[]', () {
    expect(feeds[0].readingList, rl0);
    expect(feeds[1].readingList, rl1);
  });

  test('areChaptersRead', () {
    expect(feeds.areChaptersRead, false);
    feeds[1].toggleIsRead();
    expect(feeds.areChaptersRead, true);
  });

  test('lastModifiedFeed', () {
    feeds[0].toggleIsRead();
    expect(feeds.lastModifiedFeed, feeds[0]);
    feeds[1].toggleIsRead();
    expect(feeds.lastModifiedFeed, feeds[1]);
    feeds[0].toggleIsRead();
    expect(feeds.lastModifiedFeed, feeds[0]);
  });
}
