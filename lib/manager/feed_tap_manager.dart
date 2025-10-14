import 'package:injectable/injectable.dart';

import '../model/bible_reader_launch_result.dart';
import '../model/feed.dart';
import '../service/haptic_service.dart';
import 'bible_reader_launch_manager.dart';
import 'bible_reader_link_manager.dart';

@lazySingleton
class FeedTapManager {
  final BibleReaderLaunchManager _bibleReaderLaunchManager;
  final BibleReaderLinkManager _bibleReaderLinkManager;
  final HapticService _hapticService;

  FeedTapManager(this._bibleReaderLaunchManager, this._bibleReaderLinkManager, this._hapticService);

  Future<BibleReaderLaunchResult> handleTap(Feed feed) {
    _hapticService.impact();
    feed.toggleIsRead();
    final linkedBibleReader = _bibleReaderLinkManager.linkedBibleReader;
    return _bibleReaderLaunchManager.maybeLaunch(linkedBibleReader, feed.state);
  }
}
