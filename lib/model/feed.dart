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
  Feed(this._readingList) {
    sl<FeedPersisterService>().loadStateOrDefaults(this);
    notifyListeners();
  }

  // book
  late Book _book;
  Book get book => _book;
  @visibleForTesting
  set book(Book b) {
    _book = b;
  }

  // chapter
  late int _chapter;
  int get chapter => _chapter;
  @visibleForTesting
  set chapter(int c) {
    assert(c > 0);
    assert(c <= book.chapterCount);
    _chapter = c;
  }

  // isChapterRead
  late bool _isChapterRead;
  bool get isChapterRead => _isChapterRead;
  @visibleForTesting
  set isChapterRead(bool val) {
    _isChapterRead = val;
    notifyListeners();
  }

  // date last saved
  late DateTime? _dateLastSaved;
  DateTime? get dateLastSaved => _dateLastSaved;

  // reading list
  final ReadingList _readingList;
  ReadingList get readingList => _readingList;
}
