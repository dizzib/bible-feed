import 'package:injectable/injectable.dart';

import 'setting_manager.dart';

@lazySingleton
class CatchupSettingManager extends SettingManager {
  CatchupSettingManager(super.sharedPreferences);

  @override
  bool get canEnable => true;

  @override
  get storeKey => 'isEnabled.catchup';

  @override
  String get title => 'Catch Up';

  @override
  String get subtitle => 'Warn if you miss your daily bread, and help keep track of your recovery.';
}
