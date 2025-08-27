import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/service/feed_store_service.dart';
import 'package:bible_feed/service/verse_scope_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import '../stub/reading_list_stub.dart';

void main() async {
  late Feeds testee;

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

  setUp(() async {
    testee = Feeds(
      di<FeedStoreService>(),
      di<VerseScopeService>(),
      di<ReadingLists>(),
    );
  });

  test('[]', () {
    expect(testee[0].readingList, rl0);
    expect(testee[1].readingList, rl1);
  });

  test('areChaptersRead', () {
    expect(testee.areChaptersRead, false);
    testee[1].toggleIsRead();
    expect(testee.areChaptersRead, true);
  });

  test('lastModifiedFeed', () {
    testee[0].toggleIsRead();
    expect(testee.lastModifiedFeed, testee[0]);
    testee[1].toggleIsRead();
    expect(testee.lastModifiedFeed, testee[1]);
    testee[0].toggleIsRead();
    expect(testee.lastModifiedFeed, testee[0]);
  });
}
