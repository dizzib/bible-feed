part of '../feed.dart';

// an individual book e.g. Matthew, with reading state
class Book {
  final String key;  // e.g. mat
  final String _name;  // e.g. Matthew
  final List<int> _chapters;

  Book(
    this.key,
    this._name,
    int chapterCount
  ) : _chapters = List<int>.generate(chapterCount, (n) => n);

  // state
  int _index = 0;
  bool _isChapterRead = false;

  // private
  void _reset() { _index = 0; _isChapterRead = false; }

  // testing
  @visibleForTesting set chapter(int val) => _index = val - 1;
  @visibleForTesting get chaptersRead => _index + (isChapterRead ? 1 : 0);
  @visibleForTesting set isChapterRead(bool val) => _isChapterRead = val;
  @visibleForTesting void nextChapter() {
    assert(_isChapterRead);
    _index = ++_index % count;
    isChapterRead = false;
  }

  // public
  int get chapter => 1 + _index;
  int get count => _chapters.length;
  bool get isChapterRead => _isChapterRead;
  get name => _name;
}
