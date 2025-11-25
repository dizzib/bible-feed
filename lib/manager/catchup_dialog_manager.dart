import 'package:injectable/injectable.dart';

import 'catchup_manager.dart';
import 'dialog_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class CatchupDialogManager extends DialogManager {
  final CatchupManager _catchupManager;
  final FeedsManager _feedsManager;

  CatchupDialogManager(super._storeService, this._catchupManager, this._feedsManager) {
    _catchupManager.addListener(() {
      // For onboarding, auto-show dialog only if onboarding not completed
      if (_catchupManager.isBehind && !hasCompletedOnboarding) show();
    });
  }

  @override
  String get onboardingStoreKeyFragment => 'catchup';

  //// ui

  @override
  String get closeText => 'Close';

  @override
  String Function() get getText => () {
    final daysBehind = _catchupManager.daysBehind;
    return "You are $daysBehind day${daysBehind == 1 ? '' : 's'} behind, and have $chaptersToRead more chapters to read today.\n\nThis alert can be disabled in settings.";
  };

  @override
  String get title => 'Catchup alert!';

  //// other
  int get chaptersToRead => _catchupManager.daysBehind * _feedsManager.feeds.length + _feedsManager.chaptersToRead;
}
