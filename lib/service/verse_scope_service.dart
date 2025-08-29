import 'package:injectable/injectable.dart';

import '/model/feed.dart';
import '/model/verse_scopes.dart';
import 'verse_scope_toggler_service.dart';

@lazySingleton
class VerseScopeService {
  final VerseScopes _verseScopes;
  final VerseScopeTogglerService _verseScopeTogglerService;

  VerseScopeService(this._verseScopes, this._verseScopeTogglerService);

  _getVerseScope(FeedState state) {
    if (!_verseScopeTogglerService.isEnabled) return null;
    return _verseScopes[state.book.key]?[state.chapter]; // null, or int, or a map<int, string>
  }

  _toNonBreakingWhitespace(String label) => label.replaceAll('_', String.fromCharCode(0x00A0));

  int nextVerse(FeedState state) {
    final verseScope = _getVerseScope(state);
    if (verseScope == null) return 1;
    if (verseScope is int) return (state.verse == 1) ? verseScope : 1;
    assert(verseScope is Map<int, String>);
    final verses = verseScope.keys.toList();
    final index = verses.indexOf(state.verse) + 1;
    if (index == verses.length) return 1;
    return verses[index];
  }

  String verseScopeName(FeedState state) {
    final verseScope = _getVerseScope(state);
    if (verseScope == null) return '';
    if (verseScope is Map<int, String>) return _toNonBreakingWhitespace(verseScope[state.verse]!);
    return _toNonBreakingWhitespace(
        (state.verse == 1) ? 'to_verse_${nextVerse(state) - 1}' : 'from_verse_${state.verse}');
  }
}
