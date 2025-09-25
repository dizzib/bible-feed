import 'dart:io';

import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

class PlatformService {
  PlatformService({required this.isAndroid, required this.isIOS, required this.isHapticAvailable});

  final bool isAndroid;
  final bool isIOS;
  final bool isHapticAvailable;
}

@prod
@LazySingleton(as: PlatformService)
class ProductionPlatformService extends PlatformService {
  ProductionPlatformService({required super.isAndroid, required super.isIOS, required super.isHapticAvailable});

  @factoryMethod
  @preResolve
  static Future<PlatformService> create() async => PlatformService(
    isAndroid: Platform.isAndroid,
    isIOS: Platform.isIOS,
    isHapticAvailable: await Haptics.canVibrate(),
  );
}

@Environment('screenshot')
@LazySingleton(as: PlatformService)
class ScreenshotPlatformService extends PlatformService {
  ScreenshotPlatformService() : super(isAndroid: true, isIOS: false, isHapticAvailable: true);
}
