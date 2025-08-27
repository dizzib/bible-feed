import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'toggler_service.dart';

@lazySingleton
class HapticService extends RouteObserver<PageRoute<dynamic>> {
  final HapticTogglerService _hapticTogglerService;

  HapticService(this._hapticTogglerService);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => impact();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => impact();

  void impact() {
    if (_hapticTogglerService.isEnabled) HapticFeedback.lightImpact();
  }
}
