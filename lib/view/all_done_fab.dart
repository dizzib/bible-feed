import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../model/feeds.dart';
import '../util/build_context.dart';
import 'all_done_dialog.dart';

class AllDoneFab extends WatchingWidget {
  @override
  build(context) {
    final feeds = watchIt<Feeds>();

    void showAllDoneDialog() { context.showBlurBackgroundDialog(AllDoneDialog()); }

    // auto-show dialog once only
    if (feeds.areChaptersRead && !feeds.hasEverAdvanced) Future.delayed(Duration.zero, showAllDoneDialog);

    return AnimatedScale(
      curve: Curves.fastEaseInToSlowEaseOut,
      duration: const Duration(milliseconds: 500),
      scale: feeds.areChaptersRead ? 1 : 0,
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: showAllDoneDialog,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.done,
          size: 35,
        ),
      ),
    );
  }
}
