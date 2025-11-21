import 'package:injectable/injectable.dart';

import 'setting_manager.dart';

@lazySingleton
class CatchupSettingManager extends SettingManager {
  CatchupSettingManager(super.sharedPreferences);

  @override
  bool get canEnable => true;

  @override
  bool get defaultValue => true;

  @override
  get storeKey => 'isEnabled.catchup';

  @override
  String get title => 'Catch Up';

  @override
  String get subtitle => 'Warn if you miss your daily 10 chapters, and keep track of your recovery.';
}
