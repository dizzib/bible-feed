import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/model/feed.dart';
import '/model/reading_lists.dart';
import 'feed_store_service.dart';

@lazySingleton
class FeedsService with ChangeNotifier {
  final FeedStoreService _feedStoreService;

  FeedsService(this._feedStoreService, ReadingLists readingLists)
    : _feeds = readingLists.map((rl) => Feed(rl, _feedStoreService.loadState(rl))).toList() {
    for (Feed f in _feeds) {
      if (f.state.dateModified?.isAfter(_lastModifiedFeed?.state.dateModified ?? DateTime(0)) ?? false) {
        _lastModifiedFeed = f;
      }

      f.addListener(() {
        notifyListeners();
        _lastModifiedFeed = f;
        _feedStoreService.saveState(f.readingList, f.state);
      });
    }
  }

  final List<Feed> _feeds;
  Feed? _lastModifiedFeed;

  bool get areChaptersRead => _feeds.where((feed) => !feed.state.isRead).isEmpty;
  List<Feed> get feeds => _feeds;
  Feed? get lastModifiedFeed => _lastModifiedFeed;
}
