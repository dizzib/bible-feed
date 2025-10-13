import 'package:flutter/foundation.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

import '/injectable.env.dart';

class PlatformService {
  PlatformService({required this.currentPlatform, required this.isHapticAvailable});

  final TargetPlatform currentPlatform;
  final bool isHapticAvailable;

  bool get isAndroid => currentPlatform == TargetPlatform.android;
  bool get isIOS => currentPlatform == TargetPlatform.iOS;
}

@midnightTest
@prod
@LazySingleton(as: PlatformService)
class ProductionPlatformService extends PlatformService {
  ProductionPlatformService({required super.currentPlatform, required super.isHapticAvailable});

  @factoryMethod
  @preResolve
  static Future<PlatformService> create() async =>
      PlatformService(currentPlatform: defaultTargetPlatform, isHapticAvailable: await Haptics.canVibrate());
}
