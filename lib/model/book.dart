// an individual book e.g. Matthew, with reading state
final class Book {
  final String key;  // e.g. mat
  final String name;  // e.g. Matthew
  final int chapterCount;

  Book(this.key, this.name, this.chapterCount);

  // state
  int chapter = 1;
  bool isChapterRead = false;

  /// properties
  int get chaptersRead => chapter + (isChapterRead ? 1 : 0) - 1;

  /// methods
  void nextChapter() {
    assert(isChapterRead);
    if (++chapter > chapterCount) chapter = 1;
    isChapterRead = false;
  }

  void reset() { chapter = 1; isChapterRead = false; }
}
