import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

import '/injectable.env.dart';

class HapticAvailabilityService {
  HapticAvailabilityService({required this.isHapticAvailable});

  final bool isHapticAvailable;
}

@midnightTest
@prod
@LazySingleton(as: HapticAvailabilityService)
class ProductionHapticAvailabilityService extends HapticAvailabilityService {
  ProductionHapticAvailabilityService({required super.isHapticAvailable});

  @factoryMethod
  @preResolve
  static Future<HapticAvailabilityService> create() async =>
      HapticAvailabilityService(isHapticAvailable: await Haptics.canVibrate());
}
