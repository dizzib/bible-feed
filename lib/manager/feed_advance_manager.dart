import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import 'chapter_split_manager.dart';

@lazySingleton
class FeedAdvanceManager {
  final ChapterSplitManager _chapterSplitService;

  FeedAdvanceManager(this._chapterSplitService);

  void advance(Feed feed) {
    final state = feed.state;
    assert(state.isRead);
    var bookIndex = feed.bookIndex;
    var chapter = state.chapter;
    final verse = _chapterSplitService.getNextVerse(state);
    if (verse == 1 && ++chapter > state.book.chapterCount) {
      bookIndex = (feed.bookIndex + 1) % feed.readingList.length;
      chapter = 1;
    }
    feed.setBookChapterVerse(bookIndex, chapter, verse);
  }
}
