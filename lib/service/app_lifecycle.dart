import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../model/feeds.dart';

class AppLifecycle {
  AppLifecycle() {
    AppLifecycleListener(onResume: () {
      di<Feeds>().maybeAdvance();
    });
  }
}
