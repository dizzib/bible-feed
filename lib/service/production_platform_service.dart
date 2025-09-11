import 'dart:io';

import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

import 'platform_service.dart';

@prod
@LazySingleton(as: PlatformService)
class ProductionPlatformService extends PlatformService {
  ProductionPlatformService({required super.isAndroid, required super.isIOS, required super.isHapticAvailable});

  @factoryMethod
  @preResolve
  static Future<ProductionPlatformService> create() async => ProductionPlatformService(
    isAndroid: Platform.isAndroid,
    isIOS: Platform.isIOS,
    isHapticAvailable: await Haptics.canVibrate(),
  );
}
