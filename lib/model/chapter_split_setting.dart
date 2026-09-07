import 'package:injectable/injectable.dart';

import 'setting.dart';

@lazySingleton
class ChapterSplitSetting extends Setting<bool> {
  @override
  bool get defaultValue => false;

  @override
  String get storeKeyFragment => 'splitChapters';

  @override
  String get title => 'Split Chapters';

  @override
  String get subtitle => 'Split long chapters, such as Psalm 119, into shorter sections.';
}
