import 'package:injectable/injectable.dart';

import '/model/feed.dart';

@lazySingleton
class VerseScopeService {
  Map<int, String>? _verseScopeMap(Feed f) => f.book.verseScopeMaps?[f.chapter];

  int nextVerse(Feed f) {
    final vsm = _verseScopeMap(f);
    if (vsm == null) return 1;
    final verses = vsm.keys.toList();
    final index = verses.indexOf(f.verse) + 1;
    if (index == verses.length) return 1;
    return verses[index];
  }

  String verseScopeName(Feed f) {
    final vsm = _verseScopeMap(f);
    if (vsm == null) return '';
    return vsm[f.verse]!.replaceAll('_', String.fromCharCode(0x00A0));
  }
}
