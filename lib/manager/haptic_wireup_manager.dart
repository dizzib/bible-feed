import 'package:injectable/injectable.dart';

import '../model/list_wheel_state.dart';
import '../service/haptic_service.dart';
import 'bible_reader_link_manager.dart';
import 'chapter_split_setting_manager.dart';
import 'haptic_setting_manager.dart';

@singleton
class HapticWireupManager {
  final HapticService _hapticService;
  final ChapterSplitSettingManager _chapterSplitSettingService;
  final HapticSettingManager _hapticSettingManager;
  final BibleReaderLinkManager _bibleReaderLinkManager;
  final BookListWheelState _bookListWheelState;
  final ChapterListWheelState _chapterListWheelState;

  HapticWireupManager(
    this._hapticService,
    this._chapterSplitSettingService,
    this._hapticSettingManager,
    this._bibleReaderLinkManager,
    this._bookListWheelState,
    this._chapterListWheelState,
  ) {
    _bibleReaderLinkManager.addListener(_hapticService.impact);
    _bookListWheelState.addListener(_hapticService.impact);
    _chapterListWheelState.addListener(_hapticService.impact);
    _chapterSplitSettingService.addListener(_hapticService.impact);
    _hapticSettingManager.addListener(_hapticService.impact);
  }
}
