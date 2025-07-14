import 'package:bible_feed/util/build_context.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'settings.dart';

class SettingsFab extends WatchingWidget {
  @override
  build(context) {
    return FloatingActionButton(
      onPressed: () => context.showBlurBackgroundDialog(Settings()),
      shape: const CircleBorder(),
      child: const Icon(
        Icons.settings,
        size: 35,
      ),
    );
  }
}
