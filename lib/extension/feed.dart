part of '/model/feed.dart';

extension CalculatedGetters on Feed {
  int get bookIndex => readingList.indexOf(_book);
  int get chaptersRead => chapter + (_isChapterRead ? 1 : 0) - 1;
  double get progress => readingList.progressTo(bookIndex, chaptersRead);
}

extension PublicMethods on Feed {
  Future<void> nextChapter() async {
    assert(isChapterRead);
    void nextBook() => _book = readingList[(bookIndex + 1) % readingList.count];
    if (++_chapter > _book.chapterCount) {
      nextBook();
      _chapter = 1;
    }
    isChapterRead = false; // invoke notifyListeners by calling public setter rather than setting private field
    await sl<FeedPersisterService>().saveState(this);
  }

  Future<void> setBookAndChapter(int bookIndex, int chapter) async {
    if (bookIndex == this.bookIndex && chapter == this.chapter) return;
    _book = readingList[bookIndex];
    _chapter = chapter;
    isChapterRead = false; // invoke notifyListeners
    await sl<FeedPersisterService>().saveState(this);
  }

  Future<void> toggleIsChapterRead() async {
    isChapterRead = !isChapterRead; // invoke notifyListeners
    await sl<FeedPersisterService>().saveState(this);
  }
}
