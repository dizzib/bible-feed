import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/service/bible_app_service.dart';
import 'all_done_fab.dart';
import 'settings.dart';

class AppBarMain extends WatchingWidget implements PreferredSizeWidget {
  @override
  build(context) {
    final bas = watchIt<BibleAppService>();

    return AppBar(
      leading: Icon(
        bas.isLinked ? Icons.link : Icons.link_off,
        size: 32,
      ),
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
