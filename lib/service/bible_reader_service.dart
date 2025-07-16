import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import '/model/bible_reader.dart';
import '/model/feed.dart';

enum BibleReaderKey { none, youVersion, weDevote }

class BibleReaderService with ChangeNotifier {
  BibleReaderService() {
    final sp = sl<SharedPreferences>();
    final linkedReader = sp.getString(_linkedBibleReaderStoreKey);
    _linkedBibleReaderKey = (linkedReader == null) ? BibleReaderKey.none : BibleReaderKey.values.byName(linkedReader);
    _isEnabled = sp.getBool(_isReaderEnabledStoreKey) ?? false;
  }

  //// list of readers
  static final _bibleReaders = {
    BibleReaderKey.none: NoBibleReader(),
    BibleReaderKey.youVersion: YouVersionBibleReader(),
    BibleReaderKey.weDevote: WeDevoteBibleReader()
  };

  List<BibleReader> get bibleReaderList => _bibleReaders.values.toList();

  //// reader enabled/disabled
  late bool _isEnabled;
  final _isReaderEnabledStoreKey = 'bibleReaderEnabled';

  bool get isEnabled => _isEnabled;

  set isEnabled(bool value) {
    _isEnabled = value;
    sl<SharedPreferences>().setBool(_isReaderEnabledStoreKey, _isEnabled);
    notifyListeners();
  }

  //// linked reader
  late BibleReaderKey _linkedBibleReaderKey;
  final _linkedBibleReaderStoreKey = 'linkedBibleReader';

  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;
  BibleReader get linkedBibleReader => _bibleReaders[_linkedBibleReaderKey]!;
  int get linkedBibleReaderIndex => bibleReaderList.indexOf(linkedBibleReader);

  set linkedBibleReaderIndex(int idx) {
    if (idx == linkedBibleReaderIndex) return;
    _linkedBibleReaderKey = _bibleReaders.keys.elementAt(idx);
    sl<SharedPreferences>().setString(_linkedBibleReaderStoreKey, _linkedBibleReaderKey.name);
    _isEnabled = isLinked;
    notifyListeners();
  }

  //// misc
  void launchLinkedBibleReader(Feed f) {
    if (isLinked && isEnabled && !f.isChapterRead) linkedBibleReader.launch(f);
  }
}
