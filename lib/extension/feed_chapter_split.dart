part of '/model/feed.dart';

extension ChapterSplits on Feed {
  get _chapterSplitMap => _book.chapterSplitMaps?[_chapter];
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

  String get chapterSplitName {
    if (!_isChapterSplit) return '';
    var name = _chapterSplitMap![_verse]!;
    return name.replaceAll('_', String.fromCharCode(0x00A0));
  }
}
