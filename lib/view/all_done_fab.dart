import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/feeds_service.dart';
import '../service/all_done_dialog_service.dart';
import 'all_done_dialog.dart';
import 'build_context_extension.dart';

class AllDoneFab extends WatchingWidget {
  @override
  build(context) {
    final feedsService = watchIt<FeedsService>();

    void showAllDoneDialog() {
      context.showDialogWithBlurBackground(AllDoneDialog());
      sl<AllDoneDialogService>().hasShown = true;
    }

    if (sl<AllDoneDialogService>().isAutoShow) Future(showAllDoneDialog);

    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: feedsService.areChaptersRead ? 1 : 0,
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
