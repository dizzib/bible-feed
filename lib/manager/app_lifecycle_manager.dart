import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../model/priority.dart';

@lazySingleton
class AppLifecycleManager {
  AppLifecycleManager() {
    AppLifecycleListener(onResume: runCallbacks);
  }

  final Map<Priority, List<VoidCallback>> _resumeCallbacks = {Priority.high: [], Priority.normal: [], Priority.low: []};

  // Register a callback for app-resume with optional priority.
  void onResume(VoidCallback callback, {Priority priority = Priority.normal}) {
    _resumeCallbacks[priority]!.add(callback);
  }

  // public for unit tests -- can it be made private?
  void runCallbacks() {
    // Execute HIGH > NORMAL > LOW
    for (final priority in Priority.values) {
      for (final callback in _resumeCallbacks[priority]!) {
        callback();
      }
    }
  }
}
