import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/popup_manager.dart';
import '_constants.dart';

class PopupVerses<T extends PopupManager> extends StatelessWidget {
  const PopupVerses({super.key});

  @override
  Widget build(BuildContext context) {
    final popupManager = sl<T>();
    final foregroundColor = popupManager.getForegroundColor();
    final verses = popupManager.verses ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
          verses.map((verse) {
            return Padding(
              padding: Constants.defaultPadding,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: verse.text, style: TextStyle(fontStyle: FontStyle.italic, color: foregroundColor)),
                    TextSpan(text: ' — ', style: TextStyle(color: foregroundColor)),
                    TextSpan(text: verse.reference, style: TextStyle(color: foregroundColor)),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
