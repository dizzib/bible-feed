import 'package:injectable/injectable.dart';
import 'package:watch_it/watch_it.dart';

import 'catchup_manager.dart';
import 'dialog_manager.dart';
import 'feeds_advance_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class AllDoneDialogManager extends DialogManager {
  final CatchupManager _catchupManager;
  final FeedsManager _feedsManager;

  AllDoneDialogManager(super._storeService, this._catchupManager, this._feedsManager) {
    _feedsManager.addListener(() {
      // For onboarding, auto-show dialog only the first time all chapters are read and onboarding not completed,
      // but always show if we need to catchup.
      if (_feedsManager.areChaptersRead && (!hasCompletedOnboarding || _catchupManager.isBehind)) show();
    });
  }

  @override
  String get onboardingStoreKeyFragment => 'allDone';

  // ui props

  @override
  void Function()? get action => sl<FeedsAdvanceManager>().advance;

  @override
  String? get actionText => 'Advance now >>';

  @override
  String get closeText => 'No';

  @override
  String Function() get getText => () {
    final defaultText = 'All done for today!\n\nLists will advance at midnight or you can advance them manually now.';
    final catchupText = 'You still have ${_catchupManager.chaptersToRead} more chapters to read today.';
    return _catchupManager.isBehind ? catchupText : defaultText;
  };

  @override
  String get title => 'All done!';
}
