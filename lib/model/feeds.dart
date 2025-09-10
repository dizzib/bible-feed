import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/service/feed_store_service.dart';
import '/service/verse_scope_service.dart';
import 'feed.dart';
import 'reading_lists.dart';

@lazySingleton
class Feeds extends Iterable<Feed> with ChangeNotifier {
  final FeedStoreService _feedStoreService;
  final VerseScopeService _verseScopeService;

  Feeds(this._feedStoreService, this._verseScopeService, ReadingLists readingLists) {
    _feedList = readingLists.map((rl) => Feed(rl, _verseScopeService, _feedStoreService.loadState(rl))).toList();

    for (Feed f in _feedList) {
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

  late List<Feed> _feedList;
  Feed? _lastModifiedFeed;

  Feed operator [](int i) => _feedList[i];
  bool get areChaptersRead => _feedList.where((feed) => !feed.state.isRead).isEmpty;
  Feed? get lastModifiedFeed => _lastModifiedFeed;

  @override
  Iterator<Feed> get iterator => _feedList.iterator;
}
