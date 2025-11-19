import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/auto_advance_manager.dart';
import 'all_done_dialog.dart';
import 'all_done_fab.dart';
import 'app_bar_main.dart';
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
        final allDoneFabSize = bc.maxHeight < 260 ? 44.0 : null;

        return Scaffold(
          appBar: isShowAppBar ? AppBarMain() : null,
          body: Feeds(),
          bottomSheet: AllDoneDialog(), // invisible
          floatingActionButton: Visibility(
            visible: !isShowAppBar,
            child: Stack(children: [SettingsIconButton(), SizedBox(height: allDoneFabSize, child: AllDoneFab())]),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        );
      },
    );
  }
}
