import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/dialog_manager.dart';
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

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              decoration: BoxDecoration(
                color: manager.backgroundColor(),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: Constants.defaultPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      manager.getText(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: manager.foregroundColor()),
                    ),
                  ),
                  if (manager.hasAction)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: manager.backgroundColor(),
                        foregroundColor: manager.foregroundColor(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        manager.action?.call();
                        Navigator.pop(context);
                      },
                      child: Text(manager.actionText!), // ignore: avoid-non-null-assertion, passed hasAction guard
                    ),
                ],
              ),
            ),
          );
        },
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
