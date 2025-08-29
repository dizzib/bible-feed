import 'package:injectable/injectable.dart';

import '/model/feed.dart';
import '/model/verse_scopes.dart';
import 'verse_scope_toggler_service.dart';

@lazySingleton
class VerseScopeService {
  final VerseScopes _verseScopes;
  final VerseScopeTogglerService _verseScopeTogglerService;

  VerseScopeService(this._verseScopes, this._verseScopeTogglerService);

  int nextVerse(FeedState state) {
    if (!_verseScopeTogglerService.isEnabled) return 1;
    final intOrMap = _verseScopes[state.book.key]?[state.chapter];
    if (intOrMap == null) return 1;
    if (intOrMap is int) return (state.verse == 1) ? intOrMap : 1;
    assert(intOrMap is Map<int, String>);
    final verses = intOrMap.keys.toList();
    final index = verses.indexOf(state.verse) + 1;
    if (index == verses.length) return 1;
    return verses[index];
  }

  String verseScopeName(FeedState state) {
    if (!_verseScopeTogglerService.isEnabled) return '';
    final intOrMap = _verseScopes[state.book.key]?[state.chapter];
    if (intOrMap == null) return '';
    String name;
    if (intOrMap is int) {
      name = (state.verse == 1) ? 'to_verse_${nextVerse(state) - 1}' : 'from_verse_${state.verse}';
    } else {
      name = intOrMap[state.verse] as String;
    }
    return name.replaceAll('_', String.fromCharCode(0x00A0));
  }
}
