part of '/model/feed.dart';

extension ChapterSplits on Feed {
  Map<int, String>? get _chapterSplitMap => _book.chapterSplitMaps?[_chapter];
  bool get _isChapterSplit => _chapterSplitMap != null;

  bool _advanceVerse() {
    assert(_isRead);
    if (!_isChapterSplit) return false;
    final verses = _chapterSplitMap!.keys.toList();
    final index = verses.indexOf(_verse) + 1;
    if (index == verses.length) return false;
    _verse = verses[index];
    return true;
  }

  String get chapterSplitName =>
      _isChapterSplit ? _chapterSplitMap![_verse]!.replaceAll('_', String.fromCharCode(0x00A0)) : '';
}
