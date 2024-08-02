// an individual book e.g. Matthew, with reading state
class Book {
  final String key;  // e.g. mat
  final String name;  // e.g. Matthew
  final int chapterCount;

  Book(this.key, this.name, this.chapterCount);

  // state
  int _index = 0;
  bool isChapterRead = false;

  // properties
  set chapter(int val) => _index = val - 1;
  int get chapter => 1 + _index;
  int get chaptersRead => _index + (isChapterRead ? 1 : 0);

  // methods
  void nextChapter() { assert(isChapterRead); _index = ++_index % chapterCount; isChapterRead = false; }
  void reset() { _index = 0; isChapterRead = false; }
}
