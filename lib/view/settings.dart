import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'app_version.dart';
import 'settings_bible_reader.dart';

class Settings extends WatchingWidget {
  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RawScrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              spacing: 16,
              children: [
                BibleReaderSettings(),
                const AppVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
