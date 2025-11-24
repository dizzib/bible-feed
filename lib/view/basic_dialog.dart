import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/dialog_manager.dart';
import '_build_context_extension.dart';
import '_constants.dart';

class BasicDialog<T extends DialogManager> extends WatchingWidget {
  @override
  build(context) {
    final dialogManager = sl<T>();

    dialogManager.addListener(() {
      context.showDialogWithBlurBackground(
        CupertinoAlertDialog(
          title: Text(dialogManager.title, style: context.textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Padding(
              padding: Constants.defaultPadding,
              child: Text(dialogManager.getText(), style: context.textTheme.bodyLarge),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(dialogManager.closeText)),
            if (dialogManager.hasAction)
              TextButton(
                onPressed: () {
                  dialogManager.action!();
                  Navigator.pop(context);
                },
                child: Text(dialogManager.actionText!),
              ),
          ],
        ),
      );
    });

    return const SizedBox.shrink();
  }
}
