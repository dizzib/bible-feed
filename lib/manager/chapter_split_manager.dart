import 'package:injectable/injectable.dart';

import '../model/chapter_splitters.dart';
import '../model/feed.dart';
import 'chapter_split_toggler_manager.dart';

@lazySingleton
class ChapterSplitManager {
  final ChapterSplitters _chapterSplitters;
  final ChapterSplitTogglerManager _chapterSplitTogglerManager;

  ChapterSplitManager(this._chapterSplitters, this._chapterSplitTogglerManager);

  int getNextVerse(FeedState state) =>
      _chapterSplitTogglerManager.isEnabled ? (_chapterSplitters.find(state)?.getNextVerse(state) ?? 1) : 1;

  String getLabel(FeedState state) =>
      _chapterSplitTogglerManager.isEnabled ? (_chapterSplitters.find(state)?.getLabel(state) ?? '') : '';
}
