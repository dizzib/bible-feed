import 'package:dartx/dartx.dart';
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
  final List<BibleReader> _bibleReaders;
  final SharedPreferences _sharedPreferences;

  BibleReaderService(this._bibleReaderAppInstallService, this._bibleReaders, this._sharedPreferences) {
    _bibleReaderAppInstallService.addListener(() async {
      if (await linkedBibleReader.isAvailable()) {
        notifyListeners();
      } else {
        _saveState(BibleReaderKey.none); // bible reader has been uninstalled
      }
    });
    _certifiedBibleReaders = _bibleReaders.filter((e) => e.isCertifiedForThisPlatform).toList();
    _loadState();
  }

  static const _linkedBibleReaderStoreKey = 'linkedBibleReader';

  late List<BibleReader> _certifiedBibleReaders;
  late BibleReaderKey _linkedBibleReaderKey;

  void _loadState() {
    final String? linkedReader = _sharedPreferences.getString(_linkedBibleReaderStoreKey);
    try {
      _linkedBibleReaderKey = (linkedReader == null) ? BibleReaderKey.none : BibleReaderKey.values.byName(linkedReader);
      assert(_bibleReaders.firstWhere((e) => e.key == _linkedBibleReaderKey) != null);
    } catch (e) {
      // debugPrint('EXCEPTION: ${e.toString()}');
      _linkedBibleReaderKey = BibleReaderKey.none;
    }
  }

  void _saveState(BibleReaderKey value) {
    if (value == _linkedBibleReaderKey) return;
    _linkedBibleReaderKey = value;
    _sharedPreferences.setString(_linkedBibleReaderStoreKey, value.name);
    notifyListeners();
  }

  List<BibleReader> get certifiedList => _certifiedBibleReaders;
  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;
  BibleReader get linkedBibleReader => _bibleReaders.firstWhere((e) => e.key == _linkedBibleReaderKey);
  int get linkedBibleReaderIndex => _certifiedBibleReaders.indexOf(linkedBibleReader);
  set linkedBibleReaderIndex(int value) => _saveState(_certifiedBibleReaders[value].key);

  Future launchLinkedBibleReader(FeedState state) async {
    if (isLinked && !state.isRead) {
      final ok = await linkedBibleReader.launch(state);
      if (!ok) _saveState(BibleReaderKey.none);
    }
  }
}
