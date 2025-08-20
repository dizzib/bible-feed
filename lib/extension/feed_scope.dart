part of '/model/feed.dart';

extension FeedScope on Feed {
  static const _scopes = {
    'psa': {
      119: {
        1: 'ℵ_Aleph_ℶ_Beth',
        17: 'ג_Gimel_ד_Daleth',
        33: 'ה_He_ו_Waw',
        49: 'ז_Zayin_ח_Heth',
        65: 'ט_Teth_י_Yod',
        81: 'כ_Kaph_ל_Lamed',
        97: 'מ_Mem_נ_Nun',
        113: 'ס_Samek_ע_Ayin',
        129: 'פ_Pe_צ_Tsadde',
        145: 'ק_Qoph_ר_Resh',
        161: 'ש_Shin_ת_Tau',
      }
    }
  };

  bool get isInScope => _scopes[_book.key]?[_chapter] != null;
  String get scopeName => isInScope ? _scopes[_book.key]![_chapter]![_verse]! : '';

  bool _advanceVerse() {
    assert(_isRead);
    if (!isInScope) return false;
    final verses = _scopes[_book.key]![_chapter]!.keys.toList();
    final index = verses.indexOf(_verse) + 1;
    if (index == verses.length) return false;
    _verse = verses[index];
    return true;
  }
}
