import 'package:injectable/injectable.dart';

import 'toggler_service.dart';

@lazySingleton
class VerseScopeTogglerService extends TogglerService {
  VerseScopeTogglerService(super.sharedPreferences);

  @override
  bool get canEnable => true;

  @override
  get storeKey => 'isEnabled.verseScopes';

  @override
  String get title => 'Split Chapters';

  @override
  String get subtitle => 'Split long chapters, such as Psalm 119, into smaller sections.';
}
