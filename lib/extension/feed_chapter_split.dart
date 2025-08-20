part of '/model/feed.dart';

extension ChapterSplits on Feed {
  bool get _isChapterSplit => _book.chapterSplits?[_chapter] != null;

  bool _advanceVerse() {
    assert(_isRead);
    if (!_isChapterSplit) return false;
    final verses = _book.chapterSplits![_chapter]!.keys.toList();
    final index = verses.indexOf(_verse) + 1;
    if (index == verses.length) return false;
    _verse = verses[index];
    return true;
  }

  String get chapterSplitName {
    if (!_isChapterSplit) return '';
    var name = _book.chapterSplits![_chapter]![_verse]!;
    return name.replaceAll('_', String.fromCharCode(0x00A0));
  }
}
