import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/bible_reader_service.dart';

class BibleReaderLinkIcon extends WatchingWidget {
  @override
  build(context) {
    final brs = watchIt<BibleReaderService>();

    return Tooltip(
      message: brs.isLinked ? 'The ${brs.linkedBibleReader.name} is enabled' : 'The bible reader is disabled',
      triggerMode: TooltipTriggerMode.tap,
      child: Opacity(opacity: 0.5, child: Icon(brs.isLinked ? Icons.auto_stories : Icons.visibility_off, size: 32)),
    );
  }
}
