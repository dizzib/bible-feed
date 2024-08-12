import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/build_context.dart';

class AllDone extends StatelessWidget {
  final Function() advance;
  final bool hasEverAdvanced;

  const AllDone(this.advance, this.hasEverAdvanced);

  @override
  build(context) {
    void showAllDoneDialog() {
      context.showBlurBackgroundDialog(
        CupertinoAlertDialog(
          title: Text('All done!', style: context.titleLarge),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Lists advance at midnight.', style: context.bodyLarge),
                Text('Advance now?', style: context.bodyLarge),
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
                advance();
              },  // dialog is dismissed in FeedsView
              child: const Text('Yes'),
            ),
          ],
        )
      );
    }

    // auto-show dialog once only
    if (!hasEverAdvanced) Future.delayed(Duration.zero, showAllDoneDialog);

    return FloatingActionButton(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      onPressed: showAllDoneDialog,
      shape: const CircleBorder(),
      child: const Icon(Icons.done, size: 35, ),
    );
  }
}
