import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../model/feeds.dart';
import '../util/log.dart';

class AppLifecycle {
  AppLifecycle() {
    AppLifecycleListener(onResume: () {
      'onResume'.log();
      di<Feeds>().maybeAdvance;
    });
  }
}
