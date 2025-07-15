import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/service/bible_app_service.dart';

class BibleReaderLink extends WatchingWidget {
  @override
  build(context) {
    final bas = sl<BibleAppService>();
    return Icon(bas.isLinked ? Icons.link : Icons.link_off);
  }
}
