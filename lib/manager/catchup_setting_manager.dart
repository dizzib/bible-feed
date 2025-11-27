import 'package:injectable/injectable.dart';

import 'setting_manager.dart';

@lazySingleton
class CatchupSettingManager extends SettingManager {
  CatchupSettingManager(super.sharedPreferences);

  @override
  bool get canEnable => true;

  @override
  bool get isEnabledByDefault => false;

  @override
  get storeKeyFragment => 'catchup';

  @override
  String get title => 'Catch Up';

  @override
  String get subtitle => 'Show a notification if you miss a day, to encourage you to get back on track.';
}
