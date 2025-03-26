part of 'feed.dart';

extension FeedTip on Feed {
  String? get tip {
    if (book.key != 'psa') return null;
    // split PSALM 119 over several days
    var tips = const {
      117: 'ℵ ALEPH ℶ BETH',
      119: 'ג GIMEL ד DALETH',
      120: 'ה HE ו WAW',
      121: 'ז ZAYIN ח HETH',
      122: 'ט TETH',
      123: 'י YOD',
      124: 'כ KAPH',
      125: 'ל LAMED',
      126: 'מ MEM',
      127: 'נ NUN',
      128: 'ס SAMEK',
      129: 'ע AYIN',
      130: 'פ PE',
      131: 'צ TSADDE',
      132: null,
      133: 'ק QOPH ר RESH',
      134: 'ש SHIN ת TAU',
    };
    var tip = tips[chapter];
    return tip == null ? null : '${(chapter != 119) ? '119' : ''} $tip';
  }
}
