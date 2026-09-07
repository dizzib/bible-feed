import 'package:injectable/injectable.dart';

import 'setting.dart';

@lazySingleton
class HapticSetting extends Setting<bool> {
  @override
  bool get defaultValue => false;

  @override
  String get storeKeyFragment => 'haptic';

  @override
  String get title => 'Haptic Feedback';

  @override
  String get subtitle => isAvailable ? 'Vibrate on tap or select.' : 'This device is unable to vibrate.';
}
