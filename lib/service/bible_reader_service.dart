import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/bible_reader.dart';
import '/model/bible_readers.dart';
import '/model/feed.dart';
import '/service/bible_reader_app_install_service.dart';

@lazySingleton
class BibleReaderService with ChangeNotifier {
  final BibleReaderAppInstallService _bibleReaderAppInstallService;
  final BibleReaders _bibleReaders;
  final SharedPreferences _sharedPreferences;

  BibleReaderService(this._bibleReaderAppInstallService, this._bibleReaders, this._sharedPreferences) {
    _bibleReaderAppInstallService.addListener(() async {
      if (await linkedBibleReader.isAvailable()) {
        notifyListeners();
      } else {
        _saveState(BibleReaderKey.none); // bible reader has been uninstalled
      }
    });
    _loadState();
  }

  late BibleReaderKey _linkedBibleReaderKey;
  static const _linkedBibleReaderStoreKey = 'linkedBibleReader';

  void _loadState() {
    final String? linkedReader = _sharedPreferences.getString(_linkedBibleReaderStoreKey);
    try {
      _linkedBibleReaderKey = (linkedReader == null) ? BibleReaderKey.none : BibleReaderKey.values.byName(linkedReader);
      assert(_bibleReaders.items.keys.contains(_linkedBibleReaderKey));
    } catch (e) {
      debugPrint('EXCEPTION: ${e.toString()}');
      _linkedBibleReaderKey = BibleReaderKey.none;
    }
  }

  void _saveState(BibleReaderKey value) {
    if (value == _linkedBibleReaderKey) return;
    _linkedBibleReaderKey = value;
    _sharedPreferences.setString(_linkedBibleReaderStoreKey, value.name);
    notifyListeners();
  }

  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;
  BibleReader get linkedBibleReader => _bibleReaders.items[_linkedBibleReaderKey]!;
  int get linkedBibleReaderIndex => _bibleReaders.certifiedList.indexOf(linkedBibleReader);
  set linkedBibleReaderIndex(int value) => _saveState(_bibleReaders.certified.keys.elementAt(value));

  Future launchLinkedBibleReader(FeedState state) async {
    if (isLinked && !state.isRead) {
      final ok = await linkedBibleReader.launch(state);
      if (!ok) _saveState(BibleReaderKey.none);
    }
  }
}
