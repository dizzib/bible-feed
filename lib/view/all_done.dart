import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';
import '../model/feeds.dart';
import '../util/build_context.dart';

class AllDone extends WatchingWidget {
  @override
  build(context) {
    final feeds = watchIt<Feeds>();

    void showAllDoneDialog() {
      context.showBlurBackgroundDialog(
        CupertinoAlertDialog(
          title: Text('All done!', style: context.textTheme.titleLarge),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Lists advance at midnight.', style: context.textTheme.bodyLarge),
                Text('Advance now?', style: context.textTheme.bodyLarge),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                feeds.forceAdvance();
              },  // dialog is dismissed in FeedsView
              child: const Text('Yes'),
            ),
          ],
        )
      );
    }

    // auto-show dialog once only
    if (!feeds.hasEverAdvanced) Future.delayed(Duration.zero, showAllDoneDialog);

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
