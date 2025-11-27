import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/popup_manager.dart';
import '_constants.dart';

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
                    TextSpan(
                      // ignore: avoid-non-ascii-symbols, long dash is ok
                      text: '— ${verse.reference}'.replaceAll(' ', Constants.nonBreakingSpace),
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
