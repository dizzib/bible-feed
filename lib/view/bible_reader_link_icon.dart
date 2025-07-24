import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/service/bible_reader_service.dart';

class BibleReaderLinkIcon extends WatchingWidget {
  @override
  build(context) {
    final brs = watchIt<BibleReaderService>();

    return Tooltip(
      message: brs.isLinked ? 'The ${brs.linkedBibleReader.displayName} is enabled' : 'The bible reader is disabled',
      child: Icon(
        brs.isLinked ? Icons.open_in_new : Icons.open_in_new_off,
        color: Colors.grey.shade600,
        size: 32,
      ),
    );
  }
}
