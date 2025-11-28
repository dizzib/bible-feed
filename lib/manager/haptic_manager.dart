import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../model/list_wheel_state.dart';
import '../service/haptic_service.dart';
import 'bible_reader_link_manager.dart';
import 'catchup_setting_manager.dart';
import 'chapter_split_setting_manager.dart';
import 'debounce_manager.dart';
import 'feed_tap_manager.dart';
import 'haptic_setting_manager.dart';

@singleton
class HapticManager extends RouteObserver<PageRoute<dynamic>> {
  final DebounceManager _debounceManager;
  final HapticService _hapticService;
  final HapticSettingManager _hapticSettingManager;

  HapticManager(
    this._debounceManager,
    this._hapticService,
    this._hapticSettingManager,
    BibleReaderLinkManager bibleReaderLinkManager,
    BookListWheelState bookListWheelState,
    CatchupSettingManager catchupSettingManager,
    ChapterListWheelState chapterListWheelState,
    ChapterSplitSettingManager chapterSplitSettingManager,
    FeedTapManager feedTapManager,
  ) {
    final notifiers = [
      bookListWheelState,
      chapterListWheelState,
      feedTapManager,
      // settings
      bibleReaderLinkManager,
      catchupSettingManager,
      chapterSplitSettingManager,
      _hapticSettingManager,
    ];
    for (final notifier in notifiers) {
      notifier.addListener(_maybeImpact);
    }
  }

  void _maybeImpact() {
    _debounceManager.run(() {
      if (_hapticSettingManager.isEnabled) _hapticService.impact();
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _maybeImpact();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _maybeImpact();
}
