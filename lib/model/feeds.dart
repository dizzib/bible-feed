import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/service/feed_store_service.dart';
import '/service/verse_scope_service.dart';
import 'base_iterable.dart';
import 'feed.dart';
import 'reading_lists.dart';

@lazySingleton
class Feeds extends BaseIterable<Feed> with ChangeNotifier {
  final FeedStoreService _feedStoreService;

  Feeds(this._feedStoreService, VerseScopeService verseScopeService, ReadingLists readingLists)
    : super(readingLists.map((rl) => Feed(rl, verseScopeService, _feedStoreService.loadState(rl))).toList()) {
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
