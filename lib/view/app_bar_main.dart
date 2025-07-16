import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/service/bible_reader_service.dart';
import 'all_done_fab.dart';
import 'bible_reader_link_icon.dart';
import 'settings.dart';

class AppBarMain extends WatchingWidget implements PreferredSizeWidget {
  @override
  build(context) {
    final bas = watchIt<BibleReaderService>();

    return AppBar(
      // automaticallyImplyLeading: false,
      leadingWidth: 120,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 8,
          children: [
            BibleReaderLinkIcon(),
            bas.isLinked
                ? Switch(
                    onChanged: (value) => bas.isEnabled = value,
                    value: bas.isEnabled,
                  )
                : Container(),
          ],
        ),
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
