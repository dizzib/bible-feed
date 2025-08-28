part of 'toggler_service.dart';

@lazySingleton
class VerseScopeTogglerService extends TogglerService {
  VerseScopeTogglerService(super.sharedPreferences);

  @override
  get _storeKey => 'isEnabled.verseScopes';

  @override
  bool get isAvailable => true;

  @override
  String get title => 'Split Chapters';

  @override
  String get subtitle => 'Split long chapters, such as Psalm 119, into smaller sections.';
}
