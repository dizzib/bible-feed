import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/auto_advance_service.dart';
import 'all_done_fab.dart';
import 'app_bar_main.dart';
import 'feeds.dart';
import 'settings_icon_button.dart';

class App extends WatchingWidget {
  @override
  build(_) {
    // dismiss dialogs on auto-advance
    registerChangeNotifierHandler(handler: (context, AutoAdvanceService _, _) => Navigator.maybePop(context));

    return LayoutBuilder(
      builder: (_, BoxConstraints bc) {
        final isShowAppBar = bc.maxHeight > 360;
        final allDoneFabSize = bc.maxHeight < 260 ? 44.0 : null;

        return Scaffold(
          appBar: isShowAppBar ? AppBarMain() : null,
          body: Feeds(),
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
