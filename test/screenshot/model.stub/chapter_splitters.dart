import 'package:bible_feed/model/chapter_splitters.dart' as base;
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@immutable
@Environment('screenshot')
@LazySingleton(as: base.ChapterSplitters)
class ChapterSplitters extends base.ChapterSplitters {
  ChapterSplitters() : super([]);
}
