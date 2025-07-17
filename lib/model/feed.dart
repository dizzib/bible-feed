import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'book.dart';
import 'reading_list.dart';

part '/extension/feed.dart';
part '/extension/feed_tip.dart';
part '/service/feed_persister_service.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  Feed(this.readingList) {
    sl<FeedPersisterService>().loadStateOrDefaults(this);
    notifyListeners();
  }

  // state
  late Book book;
  late DateTime? dateLastSaved;

  // chapter
  late int _chapter;
  int get chapter => _chapter;
  set chapter(int c) {
    assert(c > 0);
    assert(c <= book.chapterCount);
    _chapter = c;
  }

  // isChapterRead
  late bool _isChapterRead;
  bool get isChapterRead => _isChapterRead;
  @visibleForTesting
  set isChapterRead(bool val) => _isChapterRead = val;

  // public properties
  final ReadingList readingList;

  Future<void> _notifyListenersAndSave() async {
    notifyListeners(); // note: extensions cannot call notifyListeners directly
    await sl<FeedPersisterService>().saveState(this);
  }
}
