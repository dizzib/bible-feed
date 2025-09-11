import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

import 'haptic_availability_service.dart';

@prod
@LazySingleton(as: HapticAvailabilityService)
class ProductionHapticAvailabilityService extends HapticAvailabilityService {
  ProductionHapticAvailabilityService(super.isAvailable);

  @factoryMethod
  @preResolve
  static Future<ProductionHapticAvailabilityService> create() async =>
      ProductionHapticAvailabilityService(await Haptics.canVibrate());
}
