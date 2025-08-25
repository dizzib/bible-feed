import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/model/reading_lists.dart';
import '/service/feed_store_service.dart';
import '/service/verse_scope_service.dart';
import 'feed.dart';

@lazySingleton
class Feeds extends Iterable<Feed> with ChangeNotifier {
  final FeedStoreService _feedStoreService;
  final VerseScopeService _verseScopeService;
  final ReadingLists _readingLists;

  Feeds(this._feedStoreService, this._verseScopeService, this._readingLists) {
    _feedList = _readingLists.items.map((rl) => Feed(rl, _verseScopeService, _feedStoreService.loadState(rl))).toList();
    for (Feed f in _feedList) {
      f.addListener(() {
        _lastModifiedFeed = f;
        _feedStoreService.saveState(f);
        notifyListeners();
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
