part of 'toggler_service.dart';

@lazySingleton
class HapticTogglerService extends TogglerService {
  HapticTogglerService(super.sharedPreferences);

  @factoryMethod
  static Future<HapticTogglerService> create(SharedPreferences sharedPreferences) async {
    final hapticTogglerService = HapticTogglerService(sharedPreferences);
    hapticTogglerService._isAvailable = true;
    return hapticTogglerService;
  }

  late bool _isAvailable;

  @override
  get _storeKey => 'isEnabled.haptic';

  @override
  bool get isAvailable => _isAvailable;

  @override
  String get title => 'Interaction';

  @override
  String get subtitle => isAvailable ? 'Vibrate on tap or scroll.' : 'Vibration is not available on this device.';
}
