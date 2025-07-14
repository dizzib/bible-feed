import 'package:bible_feed/util/build_context.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'settings.dart';

class SettingsFab extends WatchingWidget {
  @override
  build(context) {
    // Navigator.maybePop(context); // dismiss possible dialog (originator might be cron)

    void showSettingsDialog() => context.showBlurBackgroundDialog(Settings());

    return FloatingActionButton(
      backgroundColor: Colors.blue.withValues(alpha: 0.5),
      foregroundColor: Colors.white,
      onPressed: showSettingsDialog,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.settings,
        size: 35,
      ),
    );
  }
}
