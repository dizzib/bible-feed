import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../model/list_wheel_state.dart';
import '../service/haptic_service.dart';
import 'bible_reader_link_manager.dart';
import 'catchup_setting_manager.dart';
import 'chapter_split_setting_manager.dart';
import 'feed_tap_manager.dart';
import 'haptic_setting_manager.dart';

@singleton
class HapticManager extends RouteObserver<PageRoute<dynamic>> {
  final BibleReaderLinkManager _bibleReaderLinkManager;
  final BookListWheelState _bookListWheelState;
  final ChapterListWheelState _chapterListWheelState;
  final CatchupSettingManager _catchupSettingManager;
  final ChapterSplitSettingManager _chapterSplitSettingManager;
  final FeedTapManager _feedTapManager;
  final HapticService _hapticService;
  final HapticSettingManager _hapticSettingManager;

  HapticManager(
    this._bibleReaderLinkManager,
    this._bookListWheelState,
    this._catchupSettingManager,
    this._chapterListWheelState,
    this._chapterSplitSettingManager,
    this._feedTapManager,
    this._hapticService,
    this._hapticSettingManager,
  ) {
    final notifiers = [
      _bibleReaderLinkManager,
      _bookListWheelState,
      _catchupSettingManager,
      _chapterListWheelState,
      _chapterSplitSettingManager,
      _feedTapManager,
      _hapticSettingManager,
    ];
    for (final notifier in notifiers) {
      notifier.addListener(_debounceMaybeImpact);
    }
  }

  final delay = 10.milliseconds;
  bool canRun = true;
  Timer? timer;

  void _debounceMaybeImpact() {
    if (!canRun) return; // ignore: dead_code
    canRun = false;
    timer?.cancel(); // ignore: dead_code
    timer = Timer(delay, () => canRun = true);

    Log.info(_hapticSettingManager.isEnabled);
    if (_hapticSettingManager.isEnabled) _hapticService.impact();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _debounceMaybeImpact();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _debounceMaybeImpact();
}
