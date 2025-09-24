import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/feeds.dart';
import '/service/all_done_dialog_service.dart';
import 'all_done_dialog.dart';
import 'build_context_extension.dart';

class AllDoneFab extends WatchingWidget {
  @override
  build(context) {
    final feeds = watchIt<Feeds>();

    void showAllDoneDialog() {
      context.showDialogWithBlurBackground(AllDoneDialog());
      sl<AllDoneDialogService>().isAlreadyShown = true;
    }

    if (sl<AllDoneDialogService>().isAutoShow) Future.delayed(Duration.zero, showAllDoneDialog);

    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
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
