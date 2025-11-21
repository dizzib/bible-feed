import 'package:injectable/injectable.dart';

import 'setting_manager.dart';

@lazySingleton
class ChapterSplitSettingManager extends SettingManager {
  ChapterSplitSettingManager(super.sharedPreferences);

  @override
  bool get canEnable => true;

  @override
  bool get isEnabledByDefault => false;

  @override
  get storeKey => 'isEnabled.splitChapters';

  @override
  String get title => 'Split Chapters';

  @override
  String get subtitle => 'Split long chapters, such as Psalm 119, into shorter sections.';
}
