part of 'feed.dart';

extension CalculatedGetters on Feed {
  int get bookIndex => readingList.indexOf(book);
  int get chaptersRead => chapter + (isChapterRead ? 1 : 0) - 1;
  double get progress => readingList.progressTo(bookIndex, chaptersRead);
}

extension Methods on Feed {
  void _nextBook() => book = readingList[(bookIndex + 1) % readingList.count];

  void nextChapter() {
    assert(isChapterRead);
    if (++_chapter > book.chapterCount) { _nextBook(); _chapter = 1; }
    isChapterRead = false;
    persister.saveState();
  }

  void setBookAndChapter(int bookIndex, int chapter) {
    book = readingList[bookIndex];
    this.chapter = chapter;
    isChapterRead = false;
    persister.saveState();
  }

  void toggleIsChapterRead() {
    isChapterRead = !isChapterRead;
    persister.saveState();
  }
}
