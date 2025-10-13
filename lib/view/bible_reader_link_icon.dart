import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/bible_reader_link_manager.dart';
import 'constants.dart';

class BibleReaderLinkIcon extends WatchingWidget {
  @override
  build(context) {
    final brlm = watchIt<BibleReaderLinkManager>();

    return Tooltip(
      message: brlm.isLinked ? 'The ${brlm.linkedBibleReader.name} is enabled' : 'The bible reader is disabled',
      triggerMode: TooltipTriggerMode.tap,
      child: Opacity(
        opacity: 0.5,
        child: Icon(brlm.isLinked ? Icons.auto_stories : Icons.visibility_off, size: Constants.appbarIconSize),
      ),
    );
  }
}
