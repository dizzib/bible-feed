import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/service/background_service.dart';
import '/service/bible_app_service.dart';
import 'all_done_fab.dart';
import 'feeds_view.dart';
import 'settings.dart';

class App extends WatchingStatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // this must come beneath MaterialApp Navigator
    sl<BackgroundService>().addListener(() => Navigator.maybePop(context)); // dismiss all-done dialog
  }

  @override
  build(context) {
    final bas = watchIt<BibleAppService>();
    return Scaffold(
      appBar: context.isOrientationLandscape
          ? null
          : AppBar(
              leading: Icon(bas.isLinked ? Icons.link : Icons.link_off),
              centerTitle: true,
              clipBehavior: Clip.none, // do not clip fab drop shadow
              title: AllDoneFab(),
              actions: [
                IconButton(
                    onPressed: () => context.navigateTo(Settings()),
                    icon: const Icon(
                      Icons.settings,
                      size: 35,
                    )),
              ],
            ),
      body: FeedsView(),
      floatingActionButton: context.isOrientationLandscape ? AllDoneFab() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
