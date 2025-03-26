import 'book.dart';
import 'feed_persister.dart';
import 'reading_list.dart';

part 'feed_extensions.dart';
part 'feed_tip.dart';

// Feed manages the reading state of a given list of books
class Feed {
  // state
  late Book book;
  late int _chapter;
  late bool isChapterRead;
  late DateTime? dateLastSaved;

  // chapter get/set
  int get chapter => _chapter;
  set chapter(int c) {
    assert(c > 0);
    assert(c <= book.chapterCount);
    _chapter = c;
  }

  // public properties
  late final FeedPersister persister;
  final ReadingList readingList;

  Feed(this.readingList) {
    persister = FeedPersister(this);
  }
}
