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
    _isChapterRead = false;
    await _notifyListenersAndSave();
  }

  Future<void> setBookAndChapter(int bookIndex, int chapter) async {
    _book = readingList[bookIndex];
    this.chapter = chapter;
    _isChapterRead = false;
    await _notifyListenersAndSave();
  }

  Future<void> toggleIsChapterRead() async {
    _isChapterRead = !isChapterRead;
    await _notifyListenersAndSave();
  }
}
