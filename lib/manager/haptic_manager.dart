import 'package:injectable/injectable.dart';

import '../model/list_wheel_state.dart';
import '../service/haptic_service.dart';
import 'bible_reader_link_manager.dart';
import 'catchup_setting_manager.dart';
import 'chapter_split_setting_manager.dart';
import 'haptic_setting_manager.dart';

@singleton
class HapticManager {
  final BibleReaderLinkManager _bibleReaderLinkManager;
  final BookListWheelState _bookListWheelState;
  final ChapterListWheelState _chapterListWheelState;
  final CatchupSettingManager _catchupSettingManager;
  final ChapterSplitSettingManager _chapterSplitSettingManager;
  final HapticService _hapticService;
  final HapticSettingManager _hapticSettingManager;

  HapticManager(
    this._bibleReaderLinkManager,
    this._bookListWheelState,
    this._catchupSettingManager,
    this._chapterListWheelState,
    this._chapterSplitSettingManager,
    this._hapticService,
    this._hapticSettingManager,
  ) {
    _bibleReaderLinkManager.addListener(_hapticService.impact);
    _bookListWheelState.addListener(_hapticService.impact);
    _catchupSettingManager.addListener(_hapticService.impact);
    _chapterListWheelState.addListener(_hapticService.impact);
    _chapterSplitSettingManager.addListener(_hapticService.impact);
    _hapticSettingManager.addListener(_hapticService.impact);
  }
}
