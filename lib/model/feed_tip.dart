part of 'feed.dart';

extension FeedTip on Feed {
  bool get hasTip => tip.isNotEmpty;
  String get tip {
    if (book.key != 'psa') return '';
    // split PSALM 119 over several days
    const tips = {
      117: 'ℵ_ALEPH ℶ_BETH',
      119: 'ג_GIMEL ד_DALETH',
      120: 'ה_HE ו_WAW',
      121: 'ז_ZAYIN ח_HETH',
      122: 'ט_TETH',
      123: 'י_YOD',
      124: 'כ_KAPH',
      125: 'ל_LAMED',
      126: 'מ_MEM',
      127: 'נ_NUN',
      128: 'ס_SAMEK',
      129: 'ע_AYIN',
      130: 'פ_PE',
      131: 'צ_TSADDE',
      133: 'ק_QOPH ר_RESH',
      134: 'ש_SHIN ת_TAU',
    };
    var tip = tips[chapter];
    if (tip == null) return '';
    tip = tip.replaceAll('_', String.fromCharCode(0x00A0));
    return '${(chapter != 119) ? '119' : ''} $tip';
  }
}
