import 'package:injectable/injectable.dart';

import '/model/chapter_splitters.dart';
import '/model/feed.dart';
import 'verse_scope_toggler_service.dart';

@lazySingleton
class ChapterSplitService {
  final ChapterSplitters _chapterSplitters;
  final VerseScopeTogglerService _verseScopeTogglerService;

  ChapterSplitService(this._chapterSplitters, this._verseScopeTogglerService);

  int getNextVerse(FeedState state) =>
      _verseScopeTogglerService.isEnabled ? (_chapterSplitters.find(state)?.getNextVerse(state) ?? 1) : 1;

  String getLabel(FeedState state) =>
      _verseScopeTogglerService.isEnabled ? (_chapterSplitters.find(state)?.getLabel(state) ?? '') : '';
}
