import 'package:injectable/injectable.dart';

import '../service/haptic_availability_service.dart';
import 'toggler_manager.dart';

@lazySingleton
class HapticTogglerManager extends TogglerManager {
  HapticTogglerManager(super._storeService, this._hapticAvailabilityService);

  final HapticAvailabilityService _hapticAvailabilityService;

  @override
  bool get canEnable => _hapticAvailabilityService.isHapticAvailable;

  @override
  get storeKey => 'isEnabled.haptic';

  @override
  String get title => 'Haptic Feedback';

  @override
  String get subtitle => canEnable ? 'Vibrate on tap or select.' : 'This device is unable to vibrate.';
}
