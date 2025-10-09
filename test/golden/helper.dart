import 'package:bible_feed/service/chapter_split_toggler_service.dart';
import 'package:bible_feed/service/feeds_service.dart';
import 'package:watch_it/watch_it.dart';

class Helper {
  static void enableVerseScopes() {
    sl<ChapterSplitTogglerService>().isEnabled = true;
  }

  static void initialiseFeeds() {
    var bookState = [
      [0, 1],
      [4, 1],
      [0, 0],
      [0, 5],
      [0, 0],
    ];
    var chapterState = [
      [5, 12],
      [4, 2],
      [40, 144],
      [15, 17],
      [40, 7],
    ];
    var chapterReadState = [
      [0, 1],
      [0, 0],
      [1, 0],
      [0, 1],
      [1, 0],
    ];
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 2; col++) {
        final feed = sl<FeedsService>().feeds[row * 2 + col];
        feed.setBookChapterVerse(bookState[row][col], chapterState[row][col]);
        if (chapterReadState[row][col] == 1) feed.toggleIsRead();
      }
    }
  }
}
