import 'package:injectable/injectable.dart';

import '/model/chapter_splitters.dart';
import '/model/feed.dart';
import 'chapter_split_toggler_service.dart';

@lazySingleton
class ChapterSplitService {
  final ChapterSplitters _chapterSplitters;
  final ChapterSplitTogglerService _chapterSplitTogglerService;

  ChapterSplitService(this._chapterSplitters, this._chapterSplitTogglerService);

  int getNextVerse(FeedState state) =>
      _chapterSplitTogglerService.isEnabled ? (_chapterSplitters.find(state)?.getNextVerse(state) ?? 1) : 1;

  String getLabel(FeedState state) =>
      _chapterSplitTogglerService.isEnabled ? (_chapterSplitters.find(state)?.getLabel(state) ?? '') : '';
}
