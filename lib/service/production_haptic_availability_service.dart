import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

import 'haptic_availability_service.dart';

@prod
@LazySingleton(as: HapticAvailabilityService)
class ProductionHapticAvailabilityService extends HapticAvailabilityService {
  @factoryMethod
  @preResolve
  static Future<ProductionHapticAvailabilityService> create() async {
    final has = ProductionHapticAvailabilityService();
    has._isAvailable = await Haptics.canVibrate();
    return has;
  }

  late bool _isAvailable;

  @override
  bool get isAvailable => _isAvailable;
}
