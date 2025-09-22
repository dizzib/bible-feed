import 'package:dartx/dartx.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/bible_reader.dart';
import '/model/bible_readers.dart';
import '/model/feed.dart';
import '/model.production/bible_reader_key.dart';
import 'platform_service.dart';
import 'result.dart';

@lazySingleton
class BibleReaderService with ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  BibleReaderService(this._sharedPreferences, PlatformService platformService, BibleReaders bibleReaders) {
    _certifiedBibleReaderList = bibleReaders.filter((br) => br.isCertified(platformService)).toList();
    _loadState();
  }

  static const _linkedBibleReaderStoreKey = 'linkedBibleReader';

  late List<BibleReader> _certifiedBibleReaderList;
  late BibleReaderKey _linkedBibleReaderKey;

  void _loadState() {
    final String? linkedReaderName = _sharedPreferences.getString(_linkedBibleReaderStoreKey);
    try {
      _linkedBibleReaderKey = BibleReaderKey.values.byName(linkedReaderName ?? BibleReaderKey.none.name);
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

  List<BibleReader> get certifiedBibleReaderList => _certifiedBibleReaderList;
  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;
  BibleReader get linkedBibleReader => _certifiedBibleReaderList.firstWhere((e) => e.key == _linkedBibleReaderKey);
  int get linkedBibleReaderIndex => _certifiedBibleReaderList.indexOf(linkedBibleReader);
  set linkedBibleReaderIndex(int value) => _saveState(_certifiedBibleReaderList[value].key);

  Future<Result> launchLinkedBibleReader(FeedState state) async {
    if (!isLinked || state.isRead) return Future.value(Success());
    try {
      return Future.value(await linkedBibleReader.launch(state) ? Success() : Failure());
    } on PlatformException catch (e) {
      return Future.value(Failure(e));
    }
  }

  void unlinkBibleReader() => _saveState(BibleReaderKey.none);
}
