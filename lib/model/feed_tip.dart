part of 'feed.dart';

extension FeedTip on Feed {
  bool get hasTip => tip.isNotEmpty;
  String get tip {
    if (book.key != 'psa') return '';
    // split PSALM 119 over several days
    const tips = {
      117: 'ℵ Aleph ℶ Beth',
      119: 'ג Gimel ד Daleth',
      120: 'ה He ו Waw',
      121: 'ז Zayin ח Heth',
      122: 'ט Teth',
      123: 'י Yod',
      124: 'כ Kaph',
      125: 'ל Lamed',
      126: 'מ Mem',
      127: 'נ Nun',
      128: 'ס Samek',
      129: 'ע Ayin',
      130: 'פ Pe',
      131: 'צ Tsadde',
      133: 'ק Qoph ר Resh',
      134: 'ש Shin ת Tau',
    };
    var tip = tips[chapter];
    if (tip == null) return '';
    tip = '${(chapter == 119) ? '' : '119 '}$tip';
    return tip.replaceAll(' ', String.fromCharCode(0x00A0));
  }
}
