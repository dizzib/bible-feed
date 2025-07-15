import 'package:flutter/material.dart';
import '/extension/build_context.dart';
import 'all_done_fab.dart';
import 'all_done_dialog_closer.dart';
import 'bible_reader_link.dart';
import 'feeds_view.dart';
import 'settings.dart';

// NOTE: if this widget watches the BibleReaderService the dialog closes on update. Solved by the BibleReaderLink widget.
class App extends StatelessWidget {
  @override
  build(context) {
    return Stack(textDirection: TextDirection.ltr, children: [
      AllDoneDialogCloser(),
      Scaffold(
        appBar: context.isOrientationLandscape
            ? null
            : AppBar(
                leading: BibleReaderLink(),
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
