part of '/model/feed.dart';

extension VerseScope on Feed {
  Map<int, String>? get _verseScopeMap => _book.verseScopeMaps?[_chapter];
  bool get _isVerseScope => _verseScopeMap != null;

  int _getNextVerse() {
    if (!_isVerseScope) return 1;
    final verses = _verseScopeMap!.keys.toList();
    final index = verses.indexOf(_verse) + 1;
    if (index == verses.length) return 1;
    return verses[index];
  }

  String get verseScopeName =>
      _isVerseScope ? _verseScopeMap![_verse]!.replaceAll('_', String.fromCharCode(0x00A0)) : '';
}
