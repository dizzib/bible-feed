import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'toggler_service.dart';

@lazySingleton
class HapticTogglerService extends TogglerService {
  HapticTogglerService(super.sharedPreferences);

  @factoryMethod
  static Future<HapticTogglerService> create(SharedPreferences sharedPreferences) async {
    final hapticTogglerService = HapticTogglerService(sharedPreferences);
    hapticTogglerService._isAvailable = await Haptics.canVibrate();
    return hapticTogglerService;
  }

  late bool _isAvailable;

  @override
  get storeKey => 'isEnabled.haptic';

  @override
  bool get isAvailable => _isAvailable;

  @override
  String get title => 'Interaction';

  @override
  String get subtitle => isAvailable ? 'Vibrate on tap or scroll.' : 'Vibration is not available on this device.';
}
