import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/auto_advance_service.dart';
import 'all_done_fab.dart';
import 'app_bar_main.dart';
import 'feeds_view.dart';
import 'settings_icon_button.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // this must come beneath MaterialApp Navigator
    sl<AutoAdvanceService>().addListener(() => Navigator.maybePop(context)); // dismiss all-done dialog
  }

  @override
  build(context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints bc) {
        final isShowAppBar = bc.maxHeight > 360;
        return Scaffold(
          appBar: isShowAppBar ? AppBarMain() : null,
          body: FeedsView(),
          floatingActionButton:
              !isShowAppBar
                  ? Stack(
                    children: [
                      SettingsIconButton(),
                      SizedBox(width: bc.maxHeight < 260 ? 44 : null, child: FittedBox(child: AllDoneFab())),
                    ],
                  )
                  : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        );
      },
    );
  }
}
