import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

@prod // prevent Haptics.canVibrate erroring in unit tests
@lazySingleton
class ProductionHapticAvailabilityService {
  @factoryMethod
  @preResolve
  static Future<ProductionHapticAvailabilityService> create() async {
    final hapticAvailabilityService = ProductionHapticAvailabilityService();
    hapticAvailabilityService._isAvailable = await Haptics.canVibrate();
    return hapticAvailabilityService;
  }

  late bool _isAvailable;

  bool get isAvailable => _isAvailable;
}
