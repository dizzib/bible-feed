import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AllDone extends StatelessWidget {
  final Function() advance;
  final bool hasEverAdvanced;

  const AllDone(this.advance, this.hasEverAdvanced);

  @override
  build(context) {
    void showAlert() {
      HapticFeedback.lightImpact();
      Text getText(String text, [double size = 16]) => Text(text, style: TextStyle(fontSize: size));
      showDialog(
        context: context,
        builder: (_) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: CupertinoAlertDialog(
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
        )
      );
    }

    // auto-show dialog once only
    if (!hasEverAdvanced) Future.delayed(Duration.zero, showAlert);

    return FloatingActionButton(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      onPressed: showAlert,
      shape: const CircleBorder(),
      child: const Icon(Icons.done, size: 35, ),
    );
  }
}
