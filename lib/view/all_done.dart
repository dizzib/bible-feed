import 'dart:ui';
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
      Text getText(String text, [double size = 16]) => Text(text, style: TextStyle(fontSize: size));
      context.showBlurBackgroundDialog(
        CupertinoAlertDialog(
          title: getText('All done!', 22),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                getText('Lists advance at midnight.'),
                getText('Advance now?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: getText('No'),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                advance();
              },  // dialog is dismissed in FeedsView
              child: getText('Yes'),
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
