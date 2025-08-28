import 'package:injectable/injectable.dart';

import '/model/feed.dart';
import 'verse_scope_toggler_service.dart';

@lazySingleton
class VerseScopeService {
  final VerseScopeTogglerService _verseScopeTogglerService;

  VerseScopeService(this._verseScopeTogglerService);

  int nextVerse(FeedState state) {
    if (!_verseScopeTogglerService.isEnabled) return 1;
    final verseScopeMap = state.book.verseScopeMaps?[state.chapter];
    if (verseScopeMap == null) return 1;
    final verses = verseScopeMap.keys.toList();
    final index = verses.indexOf(state.verse) + 1;
    if (index == verses.length) return 1;
    return verses[index];
  }

  String verseScopeName(FeedState state) {
    if (!_verseScopeTogglerService.isEnabled) return '';
    final verseScopeMap = state.book.verseScopeMaps?[state.chapter];
    if (verseScopeMap == null) return '';
    var name = verseScopeMap[state.verse] as String;
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
