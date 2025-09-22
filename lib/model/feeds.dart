import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/service/chapter_split_service.dart';
import '/service/feed_store_service.dart';
import 'base_list.dart';
import 'feed.dart';
import 'reading_lists.dart';

@lazySingleton
class Feeds extends BaseList<Feed> with ChangeNotifier {
  final FeedStoreService _feedStoreService;

  Feeds(this._feedStoreService, ChapterSplitService chapterSplitService, ReadingLists readingLists)
    : super(readingLists.map((rl) => Feed(rl, chapterSplitService, _feedStoreService.loadState(rl))).toList()) {
    for (Feed f in this) {
      if (f.state.dateModified?.isAfter(_lastModifiedFeed?.state.dateModified ?? DateTime(0)) ?? false) {
        _lastModifiedFeed = f;
      }

      f.addListener(() async {
        notifyListeners();
        _lastModifiedFeed = f;
        await _feedStoreService.saveState(f.readingList, f.state);
      });
    }
  }

  Feed? _lastModifiedFeed;

  bool get areChaptersRead => where((feed) => !feed.state.isRead).isEmpty;
  Feed? get lastModifiedFeed => _lastModifiedFeed;
}
