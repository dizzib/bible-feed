import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

@prod // prevent Haptics.canVibrate erroring in unit tests
@lazySingleton
class HapticAvailabilityService {
  @factoryMethod
  @preResolve
  static Future<HapticAvailabilityService> create() async {
    final hapticAvailabilityService = HapticAvailabilityService();
    hapticAvailabilityService._isAvailable = await Haptics.canVibrate();
    return hapticAvailabilityService;
  }

  late bool _isAvailable;

  bool get isAvailable => _isAvailable;
}
