import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/all_done_dialog_manager.dart';
import '../manager/days_behind_manager.dart';
import 'animated_fab.dart';

class DaysBehindFab extends WatchingWidget {
  @override
  build(context) {
    final daysBehindManager = watchIt<DaysBehindManager>();

    return AnimatedFab(
      backgroundColor: Colors.yellow,
      foregroundColor: Colors.black,
      iconData: Icons.priority_high,
      keyValue: 'days_behind_fab',
      isVisible: daysBehindManager.daysBehind > 0,
      onPressed: sl<AllDoneDialogManager>().show,
    );
  }
}
