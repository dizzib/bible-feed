import 'package:injectable/injectable.dart';

import '/model/feed.dart';
import 'toggler_service.dart';

@lazySingleton
class VerseScopeService {
  final VerseScopeTogglerService _verseScopeTogglerService;

  VerseScopeService(this._verseScopeTogglerService);

  Map<int, String>? _verseScopeMap(FeedState state) => state.book.verseScopeMaps?[state.chapter];

  int nextVerse(FeedState state) {
    if (!_verseScopeTogglerService.isEnabled) return 1;
    final vsm = _verseScopeMap(state);
    if (vsm == null) return 1;
    final verses = vsm.keys.toList();
    final index = verses.indexOf(state.verse) + 1;
    if (index == verses.length) return 1;
    return verses[index];
  }

  String verseScopeName(FeedState state) {
    if (!_verseScopeTogglerService.isEnabled) return '';
    final vsm = _verseScopeMap(state);
    if (vsm == null) return '';
    var name = vsm[state.verse] as String;
    if (name.isEmpty) {
      if (state.verse == 1) {
        name = 'to_verse_${nextVerse(state) - 1}';
      } else {
        name = 'from_verse_${state.verse}';
      }
    }
    return name.replaceAll('_', String.fromCharCode(0x00A0));
  }
}
