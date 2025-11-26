import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/catchup_popup_manager.dart';
import '../manager/catchup_manager.dart';
import 'animated_fab.dart';

class CatchupFab extends WatchingWidget {
  @override
  build(context) {
    final catchupManager = watchIt<CatchupManager>();

    return AnimatedFab(
      backgroundColor: catchupManager.isVeryBehind ? Colors.red : Colors.yellow,
      foregroundColor: catchupManager.isVeryBehind ? Colors.white : Colors.black,
      iconData: Icons.priority_high,
      keyValue: 'catchup_fab',
      isVisible: catchupManager.isBehind,
      onPressed: sl<CatchupPopupManager>().show,
    );
  }
}
