import 'package:flutter/material.dart';

import '_constants.dart';
import 'bible_reader_link_icon.dart';
import 'bible_reader_settings_chips.dart';

class BibleReaderSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultSpacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Constants.defaultSpacing,
          children: [
            BibleReaderLinkIcon(),
            Expanded(
              // https://docs.flutter.dev/ui/layout/constraints example 24-25
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Constants.defaultSpacing,
                children: [
                  const Text('Bible Reader', style: TextStyle(fontSize: 20)),
                  const Text(
                    'You can configure a bible reader to open a chapter when tapped. If the bible reader is an app, please ensure it is installed.',
                  ),
                  BibleReaderSettingsChips(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
