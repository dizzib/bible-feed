// an individual book e.g. Matthew, with reading state
class Book {
  final String key;  // e.g. mat
  final String name;  // e.g. Matthew
  final int chapterCount;

  Book(this.key, this.name, this.chapterCount);

  // state
  int _index = 0;
  bool _isChapterRead = false;

  // private
  void reset() { _index = 0; _isChapterRead = false; }

  // testing
  set chapter(int val) => _index = val - 1;
  int get chaptersRead => _index + (isChapterRead ? 1 : 0);
  set isChapterRead(bool val) => _isChapterRead = val;
  void nextChapter() {
    assert(_isChapterRead);
    _index = ++_index % chapterCount;
    _isChapterRead = false;
  }

  // public
  int get chapter => 1 + _index;
  bool get isChapterRead => _isChapterRead;
}