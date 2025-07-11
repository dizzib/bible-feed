import 'package:flutter/widgets.dart';
import 'package:watch_it/watch_it.dart';
import '/model/feeds.dart';

class AppLifecycle {
  AppLifecycle() {
    AppLifecycleListener(onResume: sl<Feeds>().maybeAdvance);
  }
}
