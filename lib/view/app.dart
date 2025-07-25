import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/service/auto_advance_service.dart';
import 'all_done_fab.dart';
import 'app_bar_main.dart';
import 'feeds_view.dart';
import 'settings.dart';

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
    return LayoutBuilder(builder: (_, BoxConstraints bc) {
      final isShowAppBar = bc.maxHeight > 260;
      return Scaffold(
        appBar: isShowAppBar ? AppBarMain() : null,
        body: FeedsView(),
        floatingActionButton: Column(children: [
          IconButton(
              onPressed: () => context.navigateTo(Settings()),
              icon: const Icon(
                Icons.settings,
                size: 32,
              )),
          Visibility(
            visible: !isShowAppBar,
            // https://stackoverflow.com/questions/52786652/how-to-change-the-size-of-floatingactionbutton
            child: SizedBox(
              width: 32,
              child: FittedBox(child: AllDoneFab()),
            ),
          ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      );
    });
  }
}
