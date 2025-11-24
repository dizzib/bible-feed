import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/dialog_manager.dart';
import '_build_context_extension.dart';
import '_constants.dart';

// class BasicDialog<T extends DialogManager> extends WatchingStatefulWidget {
//   @override
//   build(context) {
//     final dialogManager = sl<T>();
//
//     dialogManager.addListener(() {
//       context.showDialogWithBlurBackground(
//         CupertinoAlertDialog(
//           title: Text(dialogManager.title, style: context.textTheme.titleLarge),
//           content: SingleChildScrollView(
//             child: Padding(
//               padding: Constants.defaultPadding,
//               child: Text(dialogManager.getText(), style: context.textTheme.bodyLarge),
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: Text(dialogManager.closeText)),
//             if (dialogManager.hasAction)
//               TextButton(
//                 onPressed: () {
//                   dialogManager.action!();
//                   Navigator.pop(context);
//                 },
//                 child: Text(dialogManager.actionText!),
//               ),
//           ],
//         ),
//       );
//     });
//
//     return const SizedBox.shrink();
//   }
// }

class BasicDialog<T extends DialogManager> extends StatefulWidget {
  const BasicDialog({super.key});

  @override
  State<BasicDialog<T>> createState() => _BasicDialogState<T>();
}

class _BasicDialogState<T extends DialogManager> extends State<BasicDialog<T>> {
  late final T _dialogManager;
  late final VoidCallback _listener;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();

    _dialogManager = sl<T>();

    _listener = () {
      // Schedule after this frame so Theme.of(context) is safe
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        if (_isDialogShowing) return;

        _isDialogShowing = true;

        try {
          await context.showDialogWithBlurBackground(
            CupertinoAlertDialog(
              title: Text(_dialogManager.title, style: context.textTheme.titleLarge),
              content: SingleChildScrollView(
                child: Padding(
                  padding: Constants.defaultPadding,
                  child: Text(_dialogManager.getText(), style: context.textTheme.bodyLarge),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text(_dialogManager.closeText)),
                if (_dialogManager.hasAction)
                  TextButton(
                    onPressed: () {
                      _dialogManager.action?.call();
                      Navigator.pop(context);
                    },
                    child: Text(_dialogManager.actionText!),
                  ),
              ],
            ),
          );
        } finally {
          if (mounted) {
            setState(() => _isDialogShowing = false);
          } else {
            _isDialogShowing = false;
          }
        }
      });
    };

    _dialogManager.addListener(_listener);
  }

  @override
  void dispose() {
    _dialogManager.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
