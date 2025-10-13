import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import '../model/reading_lists.dart';
import 'feed_store_manager.dart';

@lazySingleton
class FeedsService with ChangeNotifier {
  final FeedStoreManager _feedStoreManager;

  FeedsService(this._feedStoreManager, ReadingLists readingLists)
    : _feeds = readingLists.map((rl) => Feed(rl, _feedStoreManager.loadState(rl))).toList() {
    for (Feed f in _feeds) {
      if (f.state.dateModified?.isAfter(_lastModifiedFeed?.state.dateModified ?? DateTime(0)) ?? false) {
        _lastModifiedFeed = f;
      }

      f.addListener(() {
        notifyListeners();
        _lastModifiedFeed = f;
        _feedStoreManager.saveState(f.readingList, f.state);
      });
    }
  }

  final List<Feed> _feeds;
  Feed? _lastModifiedFeed;

  bool get areChaptersRead => _feeds.where((feed) => !feed.state.isRead).isEmpty;
  List<Feed> get feeds => _feeds;
  Feed? get lastModifiedFeed => _lastModifiedFeed;
}
