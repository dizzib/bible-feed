import 'package:injectable/injectable.dart';

import '../model/chapter_splitters.dart';
import '../model/feed.dart';
import 'chapter_split_setting_manager.dart';

@lazySingleton
class ChapterSplitManager {
  final ChapterSplitters _chapterSplitters;
  final ChapterSplitSettingManager _chapterSplitSettingManager;

  ChapterSplitManager(this._chapterSplitters, this._chapterSplitSettingManager);

  int getNextVerse(FeedState state) =>
      _chapterSplitSettingManager.isEnabled ? (_chapterSplitters.find(state)?.getNextVerse(state) ?? 1) : 1;

  String getLabel(FeedState state) =>
      _chapterSplitSettingManager.isEnabled ? (_chapterSplitters.find(state)?.getLabel(state) ?? '') : '';
}
