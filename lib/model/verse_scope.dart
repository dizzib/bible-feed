import 'package:flutter/foundation.dart';

import 'feed.dart';

@immutable
class VerseScope {
  final String bookKey;
  final int chapter;
  final List<int> verses; // each section starts at these verse numbers, excluding verse 1

  const VerseScope(this.bookKey, this.chapter, this.verses);

  String _toNonBreakingWhitespace(String label) => label.replaceAll('_', String.fromCharCode(0x00A0));

  int getNextVerse(FeedState state) {
    assert(state.book.key == bookKey);
    assert(state.chapter == chapter);
    return verses.elementAtOrNull(verses.indexOf(state.verse) + 1) ?? 1;
  }

  String getLabel(FeedState state) {
    assert(state.book.key == bookKey);
    assert(state.chapter == chapter);
    final nextVerse = getNextVerse(state);
    if (state.verse == 1) return _toNonBreakingWhitespace('to_verse_${nextVerse - 1}');
    if (nextVerse == 1) return _toNonBreakingWhitespace('from_verse_${state.verse}');
    return _toNonBreakingWhitespace('verse_${state.verse}-${nextVerse - 1}');
  }
}
