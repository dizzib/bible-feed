import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../model/bible_reader.dart';
import '../model/bible_reader_key.dart';
import '../service/store_service.dart';
import 'bible_readers_certified_manager.dart';

@lazySingleton
class BibleReaderLinkManager with ChangeNotifier {
  final BibleReadersCertifiedManager _bibleReadersCertifiedManager;
  final StoreService _storeService;

  BibleReaderLinkManager(this._storeService, this._bibleReadersCertifiedManager) {
    _loadState();
  }

  static const _linkedBibleReaderStoreKey = 'linkedBibleReader';

  late BibleReaderKey _linkedBibleReaderKey; // ignore: avoid-late-keyword, guaranteed to be set in ctor -> _loadState

  void _loadState() {
    final String? linkedReaderName = _storeService.getString(_linkedBibleReaderStoreKey);
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
    _storeService.setString(_linkedBibleReaderStoreKey, value.name);
    notifyListeners();
  }

  List<BibleReader> get _certifiedBibleReaderList => _bibleReadersCertifiedManager.certifiedBibleReaderList;
  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;

  BibleReader get linkedBibleReader => _certifiedBibleReaderList.firstWhere((e) => e.key == _linkedBibleReaderKey);
  int get linkedBibleReaderIndex => _certifiedBibleReaderList.indexOf(linkedBibleReader);
  set linkedBibleReaderIndex(int value) => _saveState(_certifiedBibleReaderList[value].key);

  void unlinkBibleReader() => _saveState(BibleReaderKey.none);
}
