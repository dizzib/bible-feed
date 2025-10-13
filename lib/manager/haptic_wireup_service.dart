import 'package:injectable/injectable.dart';

import '../model/list_wheel_state.dart';
import '../service/haptic_service.dart';
import 'bible_reader_link_service.dart';
import 'chapter_split_toggler_service.dart';
import 'haptic_toggler_service.dart';

@singleton
class HapticWireupService {
  final HapticService _hapticService;
  final ChapterSplitTogglerService _chapterSplitTogglerService;
  final HapticTogglerService _hapticTogglerService;
  final BibleReaderLinkService _bibleReaderService;
  final BookListWheelState _bookListWheelState;
  final ChapterListWheelState _chapterListWheelState;

  HapticWireupService(
    this._hapticService,
    this._chapterSplitTogglerService,
    this._hapticTogglerService,
    this._bibleReaderService,
    this._bookListWheelState,
    this._chapterListWheelState,
  ) {
    _bibleReaderService.addListener(_hapticService.impact);
    _bookListWheelState.addListener(_hapticService.impact);
    _chapterListWheelState.addListener(_hapticService.impact);
    _chapterSplitTogglerService.addListener(_hapticService.impact);
    _hapticTogglerService.addListener(_hapticService.impact);
  }
}
