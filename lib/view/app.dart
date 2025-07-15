import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/service/bible_app_service.dart';
import 'all_done_fab.dart';
import 'all_done_dialog_closer.dart';
import 'feeds_view.dart';
import 'settings.dart';

class App extends StatelessWidget with WatchItMixin {
  @override
  build(context) {
    final bas = watchIt<BibleAppService>();
    return Stack(textDirection: TextDirection.ltr, children: [
      AllDoneDialogCloser(),
      Scaffold(
        appBar: context.isOrientationLandscape
            ? null
            : AppBar(
                leading: Icon(bas.isLinked ? Icons.link : Icons.link_off),
                centerTitle: true,
                clipBehavior: Clip.none, // do not clip drop shadow
                title: AllDoneFab(),
                actions: [
                  IconButton(
                      onPressed: () => context.showDialogNormal(Settings()),
                      icon: const Icon(
                        Icons.settings,
                        size: 35,
                      )),
                ],
              ),
        body: FeedsView(),
        floatingActionButton: context.isOrientationLandscape ? AllDoneFab() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      ),
    ]);
  }
}
