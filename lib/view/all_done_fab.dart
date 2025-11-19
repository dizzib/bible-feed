import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/all_done_dialog_manager.dart';
import '../manager/feeds_manager.dart';
import '_build_context_extension.dart';
import 'all_done_dialog.dart';
import 'animated_fab.dart';

class AllDoneFab extends WatchingWidget {
  @override
  build(context) {
    final feedsManager = watchIt<FeedsManager>();

    void showAllDoneDialog() {
      context.showDialogWithBlurBackground(AllDoneDialog());
      sl<AllDoneDialogManager>().hasShown = true;
    }

    if (sl<AllDoneDialogManager>().isAutoShow) Future(showAllDoneDialog);

    return AnimatedFab(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      iconData: Icons.done,
      isVisible: feedsManager.areChaptersRead,
      onPressed: showAllDoneDialog,
    );
  }
}
