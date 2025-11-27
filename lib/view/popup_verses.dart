import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/popup_manager.dart';
import '_constants.dart';

extension StringX on String {
  String get nonBreaking => replaceAll(' ', '\u00A0');
}

class PopupVerses<T extends PopupManager> extends StatelessWidget {
  const PopupVerses({super.key});

  @override
  Widget build(BuildContext context) {
    // golden screenshots render squares unless we specify the fontFamily
    final textStyle = TextStyle(color: sl<T>().getForegroundColor(), fontFamily: 'Roboto');
    final verses = sl<T>().verses ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
          verses.map((verse) {
            return Padding(
              padding: Constants.defaultPadding,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: verse.text, style: textStyle.copyWith(fontStyle: FontStyle.italic)),
                    TextSpan(text: ' ', style: textStyle),
                    TextSpan(text: '— ${verse.reference}'.nonBreaking, style: textStyle),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
