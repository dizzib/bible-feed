import 'package:injectable/injectable.dart';
import 'package:watch_it/watch_it.dart';

import 'dialog_manager.dart';
import 'feeds_advance_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class AllDoneDialogManager extends DialogManager {
  final FeedsManager _feedsManager;

  AllDoneDialogManager(super._storeService, this._feedsManager) {
    _feedsManager.addListener(() {
      // For onboarding, auto-show dialog only the first time all chapters are read and onboarding not completed.
      if (_feedsManager.areChaptersRead && !hasCompletedOnboarding) show();
    });
  }

  @override
  String get onboardingStoreKey => 'allDone';

  // ui props

  @override
  void Function()? get action => sl<FeedsAdvanceManager>().advance;

  @override
  String? get actionText => 'Yes';

  @override
  String get closeText => 'No';

  @override
  String Function() get getText => () => 'Lists advance at midnight.\n\nAdvance now?';

  @override
  String get title => 'All done!';
}
