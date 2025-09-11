import 'package:injectable/injectable.dart';

import 'haptic_availability_service.dart';
import 'toggler_service.dart';

@lazySingleton
class HapticTogglerService extends TogglerService {
  HapticTogglerService(super.sharedPreferences, this._hapticAvailabilityService);

  final HapticAvailabilityService _hapticAvailabilityService;

  @override
  bool get canEnable => _hapticAvailabilityService.isAvailable;

  @override
  get storeKey => 'isEnabled.haptic';

  @override
  String get title => 'Haptic Feedback';

  @override
  String get subtitle => canEnable ? 'Vibrate on tap or select.' : 'This device is unable to vibrate.';
}
