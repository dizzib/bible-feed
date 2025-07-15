import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import 'settings.dart';

class SettingsFab extends WatchingWidget {
  @override
  build(context) {
    return FloatingActionButton(
      onPressed: () => context.showDialogWithBlurBackground(Settings()),
      shape: const CircleBorder(),
      child: const Icon(
        Icons.settings,
        size: 35,
      ),
    );
  }
}
