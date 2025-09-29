import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/bible_reader_link_service.dart';
import 'constants.dart';

class BibleReaderLinkIcon extends WatchingWidget {
  @override
  build(context) {
    final brs = watchIt<BibleReaderLinkService>();

    return Tooltip(
      message: brs.isLinked ? 'The ${brs.linkedBibleReader.name} is enabled' : 'The bible reader is disabled',
      triggerMode: TooltipTriggerMode.tap,
      child: Opacity(
        opacity: 0.5,
        child: Icon(brs.isLinked ? Icons.auto_stories : Icons.visibility_off, size: Constants.appbarIconSize),
      ),
    );
  }
}
