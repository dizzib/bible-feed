import 'package:flutter/material.dart';

import '/service/chapter_split_toggler_service.dart';
import '/service/haptic_toggler_service.dart';
import 'app_version.dart';
import 'bible_reader_settings.dart';
import 'settings_toggler.dart';

class Settings extends StatelessWidget {
  @override
  build(context) {
    const spacing = 12.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RawScrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(spacing).copyWith(top: 0),
            child: Column(
              spacing: spacing,
              children: [
                BibleReaderSettings(),
                SettingsToggler<ChapterSplitTogglerService>(),
                SettingsToggler<HapticTogglerService>(),
                const AppVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
