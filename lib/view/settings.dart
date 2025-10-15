import 'package:flutter/material.dart';

import '../manager/chapter_split_setting_manager.dart';
import '../manager/haptic_setting_manager.dart';
import '_constants.dart';
import 'app_version.dart';
import 'bible_reader_settings.dart';
import 'setting.dart';

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
                Setting<ChapterSplitSettingManager>(),
                Setting<HapticSettingManager>(),
                const AppVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
