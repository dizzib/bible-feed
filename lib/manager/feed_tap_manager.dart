import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import 'bible_reader_launch_manager.dart';
import 'bible_reader_link_manager.dart';

@lazySingleton
class FeedTapManager with ChangeNotifier {
  final BibleReaderLaunchManager _bibleReaderLaunchManager;
  final BibleReaderLinkManager _bibleReaderLinkManager;

  FeedTapManager(this._bibleReaderLaunchManager, this._bibleReaderLinkManager);

  Future<void> handleTap(Feed feed) {
    notifyListeners();
    feed.toggleIsRead();
    return _bibleReaderLaunchManager.maybeLaunch(_bibleReaderLinkManager.linkedBibleReader, feed.state);
  }
}
