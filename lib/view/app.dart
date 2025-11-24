import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/all_done_dialog_manager.dart';
import '../manager/auto_advance_manager.dart';
import '../manager/catchup_dialog_manager.dart';
import 'all_done_fab.dart';
import 'app_bar_main.dart';
import 'basic_dialog.dart';
import 'catchup_fab.dart';
import 'feeds.dart';
import 'settings_icon_button.dart';

class App extends WatchingWidget {
  @override
  build(_) {
    // dismiss dialogs on auto-advance
    registerChangeNotifierHandler(handler: (context, AutoAdvanceManager _, _) => Navigator.maybePop(context));

    return LayoutBuilder(
      builder: (_, BoxConstraints bc) {
        final isShowAppBar = bc.maxHeight > 360;
        final fabSize = bc.maxHeight < 260 ? 44.0 : null;

        return Scaffold(
          appBar: isShowAppBar ? AppBarMain() : null,
          body: Feeds(),
          bottomSheet: Stack(
            children: [BasicDialog<AllDoneDialogManager>(), BasicDialog<CatchupDialogManager>()],
          ), // invisible
          floatingActionButton: Visibility(
            visible: !isShowAppBar,
            child: Stack(
              children: [
                SettingsIconButton(),
                SizedBox(height: fabSize, child: CatchupFab()),
                SizedBox(height: fabSize, child: AllDoneFab()),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        );
      },
    );
  }
}
