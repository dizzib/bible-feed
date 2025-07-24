import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import '/model/bible_reader.dart';
import '/model/bible_readers.dart';
import '/model/feed.dart';
import '/service/bible_reader_app_install_service.dart';

class BibleReaderService with ChangeNotifier {
  BibleReaderService() {
    sl<BibleReaderAppInstallService>().addListener(() async {
      if (await linkedBibleReader.isAvailable()) {
        notifyListeners();
      } else {
        _saveState(BibleReaderKey.none);
      }
    });
    _loadState();
  }

  void _loadState() {
    final linkedReader = sl<SharedPreferences>().getString(_linkedBibleReaderStoreKey);
    try {
      _linkedBibleReaderKey = (linkedReader == null) ? BibleReaderKey.none : BibleReaderKey.values.byName(linkedReader);
      assert(sl<BibleReaders>().items.keys.contains(_linkedBibleReaderKey));
    } catch (e) {
      _linkedBibleReaderKey = BibleReaderKey.none;
    }
  }

  void _saveState(BibleReaderKey value) {
    if (value == _linkedBibleReaderKey) return;
    _linkedBibleReaderKey = value;
    sl<SharedPreferences>().setString(_linkedBibleReaderStoreKey, value.name);
    notifyListeners();
  }

  late BibleReaderKey _linkedBibleReaderKey;
  final _linkedBibleReaderStoreKey = 'linkedBibleReader';

  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;
  BibleReader get linkedBibleReader => sl<BibleReaders>().items[_linkedBibleReaderKey]!;
  int get linkedBibleReaderIndex => sl<BibleReaders>().certifiedList.indexOf(linkedBibleReader);
  set linkedBibleReaderIndex(int value) => _saveState(sl<BibleReaders>().certified.keys.elementAt(value));

  void launchLinkedBibleReader(Feed f) async {
    if (isLinked && !f.isChapterRead) {
      final ok = await linkedBibleReader.launch(f);
      if (!ok) _saveState(BibleReaderKey.none);
    }
  }
}
