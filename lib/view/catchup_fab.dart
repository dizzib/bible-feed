import 'package:df_log/df_log.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/all_done_dialog_manager.dart';
import '../manager/catchup_manager.dart';
import 'animated_fab.dart';

class CatchupFab extends WatchingWidget {
  @override
  build(context) {
    final catchupManager = watchIt<CatchupManager>();
    Log.info(catchupManager.daysBehind);

    return AnimatedFab(
      backgroundColor: Colors.yellow,
      foregroundColor: Colors.black,
      iconData: Icons.priority_high,
      keyValue: 'catchup_fab',
      isVisible: catchupManager.daysBehind > 0,
      onPressed: sl<AllDoneDialogManager>().show,
    );
  }
}
