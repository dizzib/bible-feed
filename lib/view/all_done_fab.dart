import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/all_done_popup_manager.dart';
import '../manager/catchup_manager.dart';
import '../manager/feeds_manager.dart';
import 'animated_fab.dart';

class AllDoneFab extends WatchingWidget {
  @override
  build(context) {
    final catchupManager = sl<CatchupManager>();
    final feedsManager = watchIt<FeedsManager>();

    final backgroundColors = [Colors.green, Colors.yellow, Colors.red];
    final foregroundColors = [Colors.white, Colors.black, Colors.white];

    return AnimatedFab(
      backgroundColor: backgroundColors[catchupManager.daysBehindClamped],
      foregroundColor: foregroundColors[catchupManager.daysBehindClamped],
      iconData: Icons.done,
      keyValue: 'all_done_fab',
      isVisible: feedsManager.areChaptersRead,
      onPressed: sl<AllDonePopupManager>().show,
    );
  }
}
