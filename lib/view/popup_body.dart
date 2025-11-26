import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/popup_manager.dart';
import '_constants.dart';
import 'popup_verses.dart';

class PopupBody<T extends PopupManager> extends StatelessWidget {
  const PopupBody({super.key});

  @override
  Widget build(BuildContext context) {
    final popupManager = sl<T>();
    final backgroundColor = popupManager.getBackgroundColor();
    final foregroundColor = popupManager.getForegroundColor();
    final elevation = 8.0;
    final titleFontSize = 24.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: Constants.defaultPadding,
          child: Text(
            popupManager.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: foregroundColor, fontSize: titleFontSize),
          ),
        ),
        Padding(
          padding: Constants.defaultPadding,
          child: Text(popupManager.getText(), textAlign: TextAlign.center, style: TextStyle(color: foregroundColor)),
        ),
        PopupVerses<T>(),
        if (popupManager.hasAction)
          ElevatedButton(
            key: const ValueKey('popup_action'),
            style: ElevatedButton.styleFrom(
              backgroundColor: foregroundColor,
              foregroundColor: backgroundColor,
              elevation: elevation,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Constants.defaultBorderRadius)),
            ),
            onPressed: () {
              popupManager.action();
              Navigator.pop(context);
            },
            child: Text(popupManager.actionText!), // ignore: avoid-non-null-assertion, passed hasAction guard
          ),
      ],
    );
  }
}
