import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/dialog_manager.dart';
import '_build_context_extension.dart';
import '_constants.dart';

class BasicDialog<T extends DialogManager> extends StatefulWidget {
  const BasicDialog({super.key});

  @override
  State<BasicDialog<T>> createState() => _BasicDialogState<T>();
}

class _BasicDialogState<T extends DialogManager> extends State<BasicDialog<T>> {
  T? _dialogManager; // nullable instead of late
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _dialogManager = sl<T>();
    _dialogManager?.addListener(_onDialogRequested);
  }

  void _onDialogRequested() {
    final manager = _dialogManager; // Grab a local copy to avoid reading a nullable repeatedly
    if (manager == null) return;

    // Ensure safe timing
    // ignore: avoid-passing-async-when-sync-expected, must await
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (_isDialogShowing) return;

      _isDialogShowing = true;

      await context.showDialogWithBlurBackground(
        CupertinoAlertDialog(
          title: Text(manager.title, style: context.textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Padding(
              padding: Constants.defaultPadding,
              child: Text(manager.getText(), style: context.textTheme.bodyLarge),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(manager.closeText)),
            if (manager.hasAction)
              TextButton(
                onPressed: () {
                  manager.action?.call();
                  Navigator.pop(context);
                },
                child: Text(manager.actionText!), // ignore: avoid-non-null-assertion, passed hasAction guard
              ),
          ],
        ),
      );

      if (mounted) {
        setState(() => _isDialogShowing = false);
      } else {
        _isDialogShowing = false;
      }
    });
  }

  @override
  void dispose() {
    _dialogManager?.removeListener(_onDialogRequested);
    _dialogManager = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
