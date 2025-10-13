import 'package:injectable/injectable.dart';

import 'toggler_service.dart';

@lazySingleton
class ChapterSplitTogglerManager extends TogglerService {
  ChapterSplitTogglerManager(super.sharedPreferences);

  @override
  bool get canEnable => true;

  @override
  get storeKey => 'isEnabled.splitChapters';

  @override
  String get title => 'Split Chapters';

  @override
  String get subtitle => 'Split long chapters, such as Psalm 119, into shorter sections.';
}
