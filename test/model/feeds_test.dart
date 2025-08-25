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
      'l0.book': 'b0',
      'l0.chapter': 1,
      'l0.dateModified': DateTime.now().toIso8601String(),
      'l0.isRead': true,
      'l1.book': 'b1',
      'l1.chapter': 1,
      'l1.dateModified': DateTime.now().toIso8601String(),
      'l1.isRead': false,
    });
    feeds = Feeds(
      di<FeedStoreService>(),
      di<VerseScopeService>(),
      di<ReadingLists>(),
    );
  });

  test('[]', () {
    expect(feeds[0].readingList, l0);
    expect(feeds[1].readingList, l1);
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
