import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import '/model/bible_reader.dart';
import '/model/feed.dart';

enum BibleReaderKey {
  none,
  andBible,
  bibleHub,
  blueLetter,
  lifeBible,
  logosBible,
  oliveTreeApp,
  youVersionApp,
  weDevoteApp,
}

class BibleReaderService with ChangeNotifier {
  BibleReaderService() {
    final sp = sl<SharedPreferences>();
    final linkedReader = sp.getString(_linkedBibleReaderStoreKey);
    try {
      _linkedBibleReaderKey = (linkedReader == null) ? BibleReaderKey.none : BibleReaderKey.values.byName(linkedReader);
      assert(_bibleReaders.keys.contains(_linkedBibleReaderKey));
    } catch (e) {
      _linkedBibleReaderKey = BibleReaderKey.none;
    }
  }

  //// list of readers
  static final _bibleReaders = {
    BibleReaderKey.none: NoBibleReader(),
    BibleReaderKey.andBible: AndBibleReader(),
    BibleReaderKey.blueLetter: BlueLetterBibleReader(),
    BibleReaderKey.bibleHub: BibleHubBibleReader(),
    BibleReaderKey.lifeBible: LifeBibleReader(),
    BibleReaderKey.logosBible: LogosBibleReader(),
    BibleReaderKey.oliveTreeApp: OliveTreeBibleReader(),
    BibleReaderKey.weDevoteApp: WeDevoteBibleReader(),
    BibleReaderKey.youVersionApp: YouVersionBibleReader(),
  };
  final _certifiedBibleReaders = _bibleReaders.filter((entry) => entry.value.isCertifiedForThisPlatform);
  List<BibleReader> get certifiedBibleReaderList => _certifiedBibleReaders.values.toList();

  //// linked reader
  late BibleReaderKey _linkedBibleReaderKey;
  final _linkedBibleReaderStoreKey = 'linkedBibleReader';

  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;
  BibleReader get linkedBibleReader => _bibleReaders[_linkedBibleReaderKey]!;
  int get linkedBibleReaderIndex => certifiedBibleReaderList.indexOf(linkedBibleReader);

  set linkedBibleReaderIndex(int idx) {
    if (idx == linkedBibleReaderIndex) return;
    _linkedBibleReaderKey = _certifiedBibleReaders.keys.elementAt(idx);
    sl<SharedPreferences>().setString(_linkedBibleReaderStoreKey, _linkedBibleReaderKey.name);
    notifyListeners();
  }

  //// misc
  void launchLinkedBibleReader(Feed f) async {
    if (isLinked && !f.isChapterRead) {
      final ok = await linkedBibleReader.launch(f);
      if (!ok) linkedBibleReaderIndex = 0;
    }
  }
}
