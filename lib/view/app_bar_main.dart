import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'all_done_fab.dart';
import 'bible_reader_link_icon.dart';
import 'settings_icon_button.dart';
import 'share_icon_button.dart';

class AppBarMain extends WatchingWidget implements PreferredSizeWidget {
  @override
  build(context) {
    return AppBar(
      leading: BibleReaderLinkIcon(),
      centerTitle: true,
      clipBehavior: Clip.none, // do not clip fab drop shadow
      title: AllDoneFab(),
      actions: [ShareIconButton(), SettingsIconButton()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
