import 'package:bible_feed/service/toggler_service.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'app_version.dart';
import 'settings_bible_reader.dart';
import 'settings_toggler.dart';

class Settings extends WatchingWidget {
  @override
  build(context) {
    const spacing = 12.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RawScrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(spacing, 0, spacing, spacing),
            child: Column(
              spacing: spacing,
              children: [
                BibleReaderSettings(),
                SettingsToggler<VerseScopeTogglerService>() ,
                SettingsToggler<HapticTogglerService>() ,
                const AppVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
