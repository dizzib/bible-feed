part of '/model/feed.dart';

extension ChapterSplit on Feed {
  Map<int, String>? get _chapterSplitMap => _book.chapterSplitMaps?[_chapter];
  bool get _isChapterSplit => _chapterSplitMap != null;

  int _advanceVerse() {
    if (!_isChapterSplit) return 1;
    final verses = _chapterSplitMap!.keys.toList();
    final index = verses.indexOf(_verse) + 1;
    if (index == verses.length) return 1;
    return verses[index];
  }

  String get chapterSplitName =>
      _isChapterSplit ? _chapterSplitMap![_verse]!.replaceAll('_', String.fromCharCode(0x00A0)) : '';
}
