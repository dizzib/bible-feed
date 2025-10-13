import 'package:injectable/injectable.dart';

import '../service/platform_service.dart';
import 'toggler_service.dart';

@lazySingleton
class HapticTogglerService extends TogglerService {
  HapticTogglerService(super.sharedPreferences, this._platformService);

  final PlatformService _platformService;

  @override
  bool get canEnable => _platformService.isHapticAvailable;

  @override
  get storeKey => 'isEnabled.haptic';

  @override
  String get title => 'Haptic Feedback';

  @override
  String get subtitle => canEnable ? 'Vibrate on tap or select.' : 'This device is unable to vibrate.';
}
