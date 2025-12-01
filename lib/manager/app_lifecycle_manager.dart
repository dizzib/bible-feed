import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

enum AppLifecyclePriority { high, normal, low }

@lazySingleton
class AppLifecycleManager {
  AppLifecycleManager() {
    AppLifecycleListener(onResume: _handleResume);
  }

  final Map<AppLifecyclePriority, List<VoidCallback>> _resumeCallbacks = {
    AppLifecyclePriority.high: [],
    AppLifecyclePriority.normal: [],
    AppLifecyclePriority.low: [],
  };

  void _handleResume() {
    // Execute HIGH > NORMAL > LOW
    for (final priority in AppLifecyclePriority.values) {
      for (final callback in _resumeCallbacks[priority]!) {
        callback();
      }
    }
  }

  /// Register a callback for app-resume with optional priority.
  void onResume(VoidCallback callback, {AppLifecyclePriority priority = AppLifecyclePriority.normal}) {
    _resumeCallbacks[priority]!.add(callback);
  }
}
