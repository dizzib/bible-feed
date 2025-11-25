import 'package:injectable/injectable.dart';

import '../service/haptic_availability_service.dart';
import 'setting_manager.dart';

@lazySingleton
class HapticSettingManager extends SettingManager {
  HapticSettingManager(super._storeService, this._hapticAvailabilityService);

  final HapticAvailabilityService _hapticAvailabilityService;

  @override
  bool get canEnable => _hapticAvailabilityService.isHapticAvailable;

  @override
  bool get isEnabledByDefault => false;

  @override
  get storeKeyFragment => 'haptic';

  @override
  String get title => 'Haptic Feedback';

  @override
  String get subtitle => canEnable ? 'Vibrate on tap or select.' : 'This device is unable to vibrate.';
}
