import 'dart:io';

import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

import '/service/platform_service.dart' as base;

@prod
@LazySingleton(as: base.PlatformService)
class PlatformService extends base.PlatformService {
  PlatformService({required super.isAndroid, required super.isIOS, required super.isHapticAvailable});

  @factoryMethod
  @preResolve
  static Future<PlatformService> create() async => PlatformService(
    isAndroid: Platform.isAndroid,
    isIOS: Platform.isIOS,
    isHapticAvailable: await Haptics.canVibrate(),
  );
}
