import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/model/bible_reader.dart';
import '/model/bible_readers.dart';
import '/model/feed.dart';
import '/service/bible_reader_app_install_service.dart';

@lazySingleton
class BibleReaderService with ChangeNotifier {
  final BibleReaderAppInstallService bibleReaderAppInstallService;
  final BibleReaders bibleReaders;
  final SharedPreferences sharedPreferences;

  BibleReaderService(this.bibleReaderAppInstallService, this.bibleReaders, this.sharedPreferences) {
    bibleReaderAppInstallService.addListener(() async {
      if (await linkedBibleReader.isAvailable()) {
        notifyListeners();
      } else {
        _saveState(BibleReaderKey.none); // bible reader has been uninstalled
      }
    });
    _loadState();
  }

  void _loadState() {
    final linkedReader = sharedPreferences.getString(_linkedBibleReaderStoreKey);
    try {
      _linkedBibleReaderKey = (linkedReader == null) ? BibleReaderKey.none : BibleReaderKey.values.byName(linkedReader);
      assert(bibleReaders.items.keys.contains(_linkedBibleReaderKey));
    } catch (e) {
      debugPrint('EXCEPTION: ${e.toString()}');
      _linkedBibleReaderKey = BibleReaderKey.none;
    }
  }

  void _saveState(BibleReaderKey value) {
    if (value == _linkedBibleReaderKey) return;
    _linkedBibleReaderKey = value;
    sharedPreferences.setString(_linkedBibleReaderStoreKey, value.name);
    notifyListeners();
  }

  late BibleReaderKey _linkedBibleReaderKey;
  final _linkedBibleReaderStoreKey = 'linkedBibleReader';

  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;
  BibleReader get linkedBibleReader => bibleReaders.items[_linkedBibleReaderKey]!;
  int get linkedBibleReaderIndex => bibleReaders.certifiedList.indexOf(linkedBibleReader);
  set linkedBibleReaderIndex(int value) => _saveState(bibleReaders.certified.keys.elementAt(value));

  void launchLinkedBibleReader(Feed f) async {
    if (isLinked && !f.isChapterRead) {
      final ok = await linkedBibleReader.launch(f);
      if (!ok) _saveState(BibleReaderKey.none);
    }
  }
}
