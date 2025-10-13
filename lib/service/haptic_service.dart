import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../manager/haptic_toggler_manager.dart';

@lazySingleton
class HapticService extends RouteObserver<PageRoute<dynamic>> {
  final HapticTogglerManager _hapticTogglerManager;

  HapticService(this._hapticTogglerManager);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => impact();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => impact();

  void impact() {
    if (_hapticTogglerManager.isEnabled) HapticFeedback.lightImpact();
  }
}
