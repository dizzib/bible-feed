part of '/model/feed.dart';

extension FeedScope on Feed {
  static const _scopes = {
    'psa': {
      119: {
        1: 'ℵ_Aleph__ℶ_Beth',
        17: 'ג_Gimel__ד_Daleth',
        33: 'ה_He__ו_Waw',
        49: 'ז_Zayin__ח_Heth',
        65: 'ט_Teth__י_Yod',
        81: 'כ_Kaph__ל_Lamed',
        97: 'מ_Mem__נ_Nun',
        113: 'ס_Samek__ע_Ayin',
        129: 'פ_Pe__צ_Tsadde',
        145: 'ק_Qoph__ר_Resh',
        161: 'ש_Shin__ת_Tau',
      }
    }
  };

  bool get _isInScope => _scopes[_book.key]?[_chapter] != null;

  bool _advanceVerse() {
    assert(_isRead);
    if (!_isInScope) return false;
    final verses = _scopes[_book.key]![_chapter]!.keys.toList();
    final index = verses.indexOf(_verse) + 1;
    if (index == verses.length) return false;
    _verse = verses[index];
    return true;
  }

  String get scopeName {
    if (!_isInScope) return '';
    var name = _scopes[_book.key]![_chapter]![_verse]!;
    return name.replaceAll('_', String.fromCharCode(0x00A0));
  }
}
