import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/extension/build_context.dart';
import '/model/feeds.dart';
import '/service/all_done_dialog_service.dart';
import 'all_done_dialog.dart';

class AllDoneFab extends WatchingWidget {
  @override
  build(context) {
    final feeds = watchIt<Feeds>();

    void showAllDoneDialog() {
      context.showDialogWithBlurBackground(AllDoneDialog());
      sl<AllDoneDialogService>().isAlreadyShown = true;
    }

    if (sl<AllDoneDialogService>().isAutoShowAllDoneDialog) Future.delayed(Duration.zero, showAllDoneDialog);

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: feeds.areChaptersRead ? 1 : 0,
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: showAllDoneDialog,
        shape: const CircleBorder(),
        child: const Icon(Icons.done, size: 35),
      ),
    );
  }
}
