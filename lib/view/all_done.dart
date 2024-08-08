import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllDone extends StatelessWidget {
  final Function() advance;
  final bool? hasEverAdvanced;

  const AllDone(this.advance, this.hasEverAdvanced);

  @override
  build(context) {
    void showAlert() {
      Text getTextWidget(String text, [double size = 16]) { return Text(text, style: TextStyle(fontSize: size)); }
      showDialog(
        context: context,
        builder: (_) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: CupertinoAlertDialog(
            title: getTextWidget('All done!', 22),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  getTextWidget('Lists advance at midnight.'),
                  getTextWidget('Advance now?'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: getTextWidget('No'),
              ),
              TextButton(
                onPressed: () { advance(); },  // dialog is dismissed in FeedsView
                child: getTextWidget('Yes'),
              ),
            ],
          )
        )
      );
    }

    // auto-show dialog once only
    if (hasEverAdvanced != true) {  // can be null
      Future.delayed(Duration.zero, showAlert);
    }

    return FloatingActionButton(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      onPressed: showAlert,
      shape: const CircleBorder(),
      child: const Icon(Icons.done, size: 35, ),
    );
  }
}
