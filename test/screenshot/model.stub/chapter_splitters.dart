import 'package:bible_feed/model/chapter_splitters.dart' as base;
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../injectable.dart';

@screenshot
@immutable
@LazySingleton(as: base.ChapterSplitters)
class ChapterSplitters extends base.ChapterSplitters {
  ChapterSplitters() : super([]);
}
