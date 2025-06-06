part of 'feed.dart';

extension CalculatedGetters on Feed {
  int get bookIndex => readingList.indexOf(book);
  int get chaptersRead => chapter + (isChapterRead ? 1 : 0) - 1;
  double get progress => readingList.progressTo(bookIndex, chaptersRead);
}

extension PublicMethods on Feed {
  Future<void> nextChapter() async {
    assert(isChapterRead);
    void nextBook() => book = readingList[(bookIndex + 1) % readingList.count];
    if (++_chapter > book.chapterCount) {
      nextBook();
      _chapter = 1;
    }
    isChapterRead = false;
    await persister.saveState();
  }

  Future<void> setBookAndChapter(int bookIndex, int chapter) async {
    book = readingList[bookIndex];
    this.chapter = chapter;
    isChapterRead = false;
    await persister.saveState();
  }

  Future<void> toggleIsChapterRead() async {
    isChapterRead = !isChapterRead;
    await persister.saveState();
  }
}
