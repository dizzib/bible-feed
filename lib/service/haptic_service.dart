import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../manager/haptic_setting_manager.dart';

@lazySingleton
class HapticService extends RouteObserver<PageRoute<dynamic>> {
  final HapticSettingManager _hapticSettingManager;

  HapticService(this._hapticSettingManager);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => impact();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => impact();

  void impact() {
    if (_hapticSettingManager.isEnabled) HapticFeedback.lightImpact();
  }
}
