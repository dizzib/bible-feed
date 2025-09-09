import 'package:injectable/injectable.dart';

import '/model/feed.dart';
import '/model/verse_scopes.dart';
import 'verse_scope_toggler_service.dart';

@lazySingleton
class VerseScopeService {
  final VerseScopes _verseScopes;
  final VerseScopeTogglerService _verseScopeTogglerService;

  VerseScopeService(this._verseScopes, this._verseScopeTogglerService);

  String _toNonBreakingWhitespace(String label) => label.replaceAll('_', String.fromCharCode(0x00A0));

  int getNextVerse(FeedState state) {
    final verseScope = _verseScopeTogglerService.isEnabled ? (_verseScopes[state.book.key]?[state.chapter]) : null;
    if (verseScope == null) return 1;
    if (verseScope is int) return (state.verse == 1) ? verseScope : 1;
    List<int> verses = verseScope.keys.toList();
    return verses.elementAtOrNull(verses.indexOf(state.verse) + 1) ?? 1;
  }

  String getVerseScopeLabel(FeedState state) {
    final verseScope = _verseScopeTogglerService.isEnabled ? (_verseScopes[state.book.key]?[state.chapter]) : null;
    if (verseScope == null) return '';
    if (verseScope is Map<int, String>) return _toNonBreakingWhitespace(verseScope[state.verse]!);
    return _toNonBreakingWhitespace(
      (state.verse == 1) ? 'to_verse_${getNextVerse(state) - 1}' : 'from_verse_${state.verse}',
    );
  }
}
