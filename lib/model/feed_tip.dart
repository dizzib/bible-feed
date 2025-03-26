part of 'feed.dart';

extension FeedTip on Feed {
  String? get tip {
    if (book.key != 'psa') return null;
    // split PSALM 119 over several days
    var tips = const {
      117: 'ALEPH BETH',
      119: 'GIMEL DALETH',
      120: 'HE WAW',
      121: 'ZAYIN HETH',
      122: 'TETH',
      123: 'YOD',
      124: 'KAPH',
      125: 'LAMED',
      126: 'MEM',
      127: 'NUN',
      128: 'SAMEK',
      129: 'AYIN',
      130: 'PE',
      131: 'TSADDE',
      132: null,
      133: 'QOPH RESH',
      134: 'SHIN TAU',
    };
    var tip = tips[chapter];
    return tip == null ? null : '${(chapter != 119) ? '119' : ''} $tip';
  }
}
