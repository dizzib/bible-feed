import 'package:injectable/injectable.dart';

import '/model/list_wheel_state.dart';
import '../injectable.dart';
import 'bible_reader_link_service.dart';
import 'haptic_service.dart';
import 'haptic_toggler_service.dart';

@midnightTest
@prod // else errors in unit tests (see haptic_availability_service)
@singleton
class HapticWireupService {
  final HapticService _hapticService;
  final HapticTogglerService _hapticTogglerService;
  final BibleReaderLinkService _bibleReaderService;
  final BookListWheelState _bookListWheelState;
  final ChapterListWheelState _chapterListWheelState;

  HapticWireupService(
    this._hapticService,
    this._hapticTogglerService,
    this._bibleReaderService,
    this._bookListWheelState,
    this._chapterListWheelState,
  ) {
    _bibleReaderService.addListener(_hapticService.impact);
    _bookListWheelState.addListener(_hapticService.impact);
    _chapterListWheelState.addListener(_hapticService.impact);
    _hapticTogglerService.addListener(_hapticService.impact);
  }
}
