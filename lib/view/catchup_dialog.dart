import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/catchup_dialog_manager.dart';
import '../manager/catchup_manager.dart';
import '_build_context_extension.dart';
import '_constants.dart';

class CatchupDialog extends WatchingWidget {
  @override
  build(context) {
    final catchupManager = sl<CatchupManager>();
    final catchupDialogManager = sl<CatchupDialogManager>();

    catchupDialogManager.addListener(() {
      final daysBehind = catchupManager.daysBehind;

      context.showDialogWithBlurBackground(
        CupertinoAlertDialog(
          title: Text('Catchup alert!', style: context.textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Padding(
              padding: Constants.defaultPadding,
              child: Text(
                "You are $daysBehind day${daysBehind == 1 ? '' : 's'} behind, and have ${catchupDialogManager.chaptersToRead} more chapters to read today.\n\nIf you don't want to see this alert, you can disable it in settings.",
                style: context.textTheme.bodyLarge,
              ),
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
        ),
      );
    });

    return const SizedBox.shrink();
  }
}
