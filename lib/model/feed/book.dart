part of '../feed.dart';

// an individual book e.g. Matthew, with reading state
class Book {
  Book(this.key, this._name, int chapterCount) : _chapters = List<int>.generate(chapterCount, (n) => n);

  // private
  final List<int> _chapters;
  int _index = 0;
  bool _isChapterRead = false;
  final String _name;  // e.g. Matthew
  void _reset() { _index = 0; _isChapterRead = false; }

  // testing
  @visibleForTesting set chapter(int c) => _index = c - 1;
  @visibleForTesting int get chaptersRead => _index + (isChapterRead ? 1 : 0);
  @visibleForTesting set isChapterRead(bool val) => _isChapterRead = val;
  @visibleForTesting final String key;  // e.g. mat
  @visibleForTesting void nextChapter() { assert(_isChapterRead); _index = ++_index % count; isChapterRead = false; }

  // public
  int get chapter => 1 + _index;
  int get count => _chapters.length;
  bool get isChapterRead => _isChapterRead;
  String get name => _name;
}
