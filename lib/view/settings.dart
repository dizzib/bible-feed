import 'package:flutter/material.dart';

import '../manager/chapter_split_toggler_manager.dart';
import '../manager/haptic_toggler_manager.dart';
import 'app_version.dart';
import 'bible_reader_settings.dart';
import 'constants.dart';
import 'settings_toggler.dart';

class Settings extends StatelessWidget {
  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RawScrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Constants.settingsSpacing).copyWith(top: 0),
            child: Column(
              spacing: Constants.settingsSpacing,
              children: [
                BibleReaderSettings(),
                SettingsToggler<ChapterSplitTogglerManager>(),
                SettingsToggler<HapticTogglerManager>(),
                const AppVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
