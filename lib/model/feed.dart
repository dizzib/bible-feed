import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'book.dart';
import 'reading_list.dart';

part '/extension/feed.dart';
part '/service/feed_persister_service.dart';
part 'feed_tip.dart';

// Feed manages the reading state of a given list of books
class Feed with ChangeNotifier {
  // state
  late Book book;
  late int _chapter;
  late bool isChapterRead;
  late DateTime? dateLastSaved;

  Future<void> _notifyListenersAndSave() async {
    notifyListeners(); // note: extensions cannot call notifyListeners directly
    await sl<FeedPersisterService>().saveState(this);
  }

  // chapter get/set
  int get chapter => _chapter;
  set chapter(int c) {
    assert(c > 0);
    assert(c <= book.chapterCount);
    _chapter = c;
  }

  // public properties
  final ReadingList readingList;

  Feed(this.readingList) {
    sl<FeedPersisterService>().loadStateOrDefaults(this);
    notifyListeners();
  }
}
