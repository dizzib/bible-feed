import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import 'all_done_fab.dart';
import 'bible_reader_link_icon.dart';
import 'settings.dart';

class AppBarMain extends WatchingWidget implements PreferredSizeWidget {
  @override
  build(context) {
    return AppBar(
      leading: BibleReaderLinkIcon(),
      centerTitle: true,
      clipBehavior: Clip.none, // do not clip fab drop shadow
      title: AllDoneFab(),
      actions: [
        IconButton(
            onPressed: () => context.navigateTo(Settings()),
            icon: const Icon(
              Icons.settings,
              size: 32,
            )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
