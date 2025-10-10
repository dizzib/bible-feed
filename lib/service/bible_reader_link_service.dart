import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/bible_reader.dart';
import '../model/bible_reader_key.dart';
import 'bible_readers_certified_service.dart';

@lazySingleton
class BibleReaderLinkService with ChangeNotifier {
  final BibleReadersCertifiedService _bibleReadersCertifiedService;
  final SharedPreferences _sharedPreferences;

  BibleReaderLinkService(this._sharedPreferences, this._bibleReadersCertifiedService) {
    _loadState();
  }

  static const _linkedBibleReaderStoreKey = 'linkedBibleReader';

  late BibleReaderKey _linkedBibleReaderKey; // ignore: avoid-late-keyword, guaranteed to be set in ctor -> _loadState

  void _loadState() {
    final String? linkedReaderName = _sharedPreferences.getString(_linkedBibleReaderStoreKey);
    try {
      _linkedBibleReaderKey = BibleReaderKey.values.byName(linkedReaderName ?? BibleReaderKey.none.name);
      linkedBibleReader; // throws an exception if linkedBibleReader is invalid or uncertified
    } catch (e) {
      _linkedBibleReaderKey = BibleReaderKey.none;
    }
  }

  void _saveState(BibleReaderKey value) {
    if (value == _linkedBibleReaderKey) return;
    _linkedBibleReaderKey = value;
    _sharedPreferences.setString(_linkedBibleReaderStoreKey, value.name);
    notifyListeners();
  }

  List<BibleReader> get _certifiedBibleReaderList => _bibleReadersCertifiedService.certifiedBibleReaderList;
  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;

  BibleReader get linkedBibleReader => _certifiedBibleReaderList.firstWhere((e) => e.key == _linkedBibleReaderKey);
  int get linkedBibleReaderIndex => _certifiedBibleReaderList.indexOf(linkedBibleReader);
  set linkedBibleReaderIndex(int value) => _saveState(_certifiedBibleReaderList[value].key);

  void unlinkBibleReader() => _saveState(BibleReaderKey.none);
}
