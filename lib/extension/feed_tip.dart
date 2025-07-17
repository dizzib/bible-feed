part of '/model/feed.dart';

extension FeedTip on Feed {
  bool get hasTip => tip.isNotEmpty;
  String get tip {
    if (_book.key != 'psa') return '';
    // split PSALM 119 over several days
    const tips = {
      117: 'ℵ_Aleph_ℶ_Beth',
      119: 'ג_Gimel_ד_Daleth',
      120: 'ה_He_ו_Waw',
      121: 'ז_Zayin_ח_Heth',
      122: 'ט_Teth',
      123: 'י_Yod',
      124: 'כ_Kaph',
      125: 'ל_Lamed',
      126: 'מ_Mem',
      127: 'נ_Nun',
      128: 'ס_Samek',
      129: 'ע_Ayin',
      130: 'פ_Pe',
      131: 'צ_Tsadde',
      133: 'ק_Qoph_ר_Resh',
      134: 'ש_Shin_ת_Tau',
    };
    var tip = tips[_chapter];
    if (tip == null) return '';
    tip = '${(_chapter == 119) ? ' ' : ', 119_'}$tip';
    return tip.replaceAll('_', String.fromCharCode(0x00A0));
  }
}
