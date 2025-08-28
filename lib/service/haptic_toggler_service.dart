import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'toggler_service.dart';

@lazySingleton
class HapticTogglerService extends TogglerService {
  HapticTogglerService(super.sharedPreferences);

  @factoryMethod
  @preResolve
  static Future<HapticTogglerService> create(SharedPreferences sharedPreferences) async {
    final hapticTogglerService = HapticTogglerService(sharedPreferences);
    hapticTogglerService._canEnable = await Haptics.canVibrate();
    return hapticTogglerService;
  }

  late bool _canEnable;

  @override
  bool get canEnable => _canEnable;

  @override
  get storeKey => 'isEnabled.haptic';

  @override
  String get title => 'Interaction';

  @override
  String get subtitle => canEnable ? 'Vibrate on tap or scroll.' : 'Vibration is not available on this device.';
}
