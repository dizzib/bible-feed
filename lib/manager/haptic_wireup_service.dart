import 'package:injectable/injectable.dart';

import '../model/list_wheel_state.dart';
import '../service/haptic_service.dart';
import 'bible_reader_link_manager.dart';
import 'chapter_split_toggler_manager.dart';
import 'haptic_toggler_service.dart';

@singleton
class HapticWireupService {
  final HapticService _hapticService;
  final ChapterSplitTogglerManager _chapterSplitTogglerService;
  final HapticTogglerService _hapticTogglerService;
  final BibleReaderLinkManager _bibleReaderLinkManager;
  final BookListWheelState _bookListWheelState;
  final ChapterListWheelState _chapterListWheelState;

  HapticWireupService(
    this._hapticService,
    this._chapterSplitTogglerService,
    this._hapticTogglerService,
    this._bibleReaderLinkManager,
    this._bookListWheelState,
    this._chapterListWheelState,
  ) {
    _bibleReaderLinkManager.addListener(_hapticService.impact);
    _bookListWheelState.addListener(_hapticService.impact);
    _chapterListWheelState.addListener(_hapticService.impact);
    _chapterSplitTogglerService.addListener(_hapticService.impact);
    _hapticTogglerService.addListener(_hapticService.impact);
  }
}
