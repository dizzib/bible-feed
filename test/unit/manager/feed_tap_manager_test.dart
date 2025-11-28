import 'package:bible_feed/manager/bible_reader_launch_manager.dart';
import 'package:bible_feed/manager/bible_reader_link_manager.dart';
import 'package:bible_feed/manager/feed_tap_manager.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'feed_tap_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BibleReaderLaunchManager>(), MockSpec<BibleReaderLinkManager>()])
void main() {
  late MockBibleReaderLaunchManager mockLaunchManager;
  late MockBibleReaderLinkManager mockLinkManager;
  late FeedTapManager feedTapManager;

  setUp(() {
    mockLaunchManager = MockBibleReaderLaunchManager();
    mockLinkManager = MockBibleReaderLinkManager();
    feedTapManager = FeedTapManager(mockLaunchManager, mockLinkManager);
  });

  test('handleTap toggles read, and launches reader', () async {
    final feed = Feed(rl0, FeedState(bookKey: b0.key));
    when(mockLinkManager.linkedBibleReader).thenReturn(blbBibleReader);

    await feedTapManager.handleTap(feed);

    expect(feed.state.isRead, true);
    verify(mockLaunchManager.maybeLaunch(blbBibleReader, feed.state)).called(1);
  });
}
