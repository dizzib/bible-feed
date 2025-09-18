import 'package:dartx/dartx.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/bible_reader.dart';
import '/model/bible_reader_keys.dart';
import '/model/bible_readers.dart';
import '/model/feed.dart';
import '/service/bible_reader_app_install_service.dart';
import 'platform_service.dart';
import 'result.dart';

@lazySingleton
class BibleReaderService with ChangeNotifier {
  final BibleReaderAppInstallService _bibleReaderAppInstallService;
  final SharedPreferences _sharedPreferences;

  BibleReaderService(
    this._bibleReaderAppInstallService,
    this._sharedPreferences,
    PlatformService platformService,
    BibleReaders bibleReaders,
  ) {
    _bibleReaderAppInstallService.addListener(() async {
      if (await linkedBibleReader.isAvailable()) {
        notifyListeners();
      } else {
        _saveState(BibleReaderKeys.none); // bible reader has been uninstalled
      }
    });
    _certifiedBibleReaderList = bibleReaders.filter((br) => br.isCertified(platformService)).toList();
    _loadState();
  }

  static const _linkedBibleReaderStoreKey = 'linkedBibleReader';

  late List<BibleReader> _certifiedBibleReaderList;
  late BibleReaderKeys _linkedBibleReaderKey;

  void _loadState() {
    final String? linkedReaderName = _sharedPreferences.getString(_linkedBibleReaderStoreKey);
    try {
      _linkedBibleReaderKey = BibleReaderKeys.values.byName(linkedReaderName ?? BibleReaderKeys.none.name);
    } catch (e) {
      // debugPrint('EXCEPTION: ${e.toString()}');
      _linkedBibleReaderKey = BibleReaderKeys.none;
    }
  }

  void _saveState(BibleReaderKeys value) {
    if (value == _linkedBibleReaderKey) return;
    _linkedBibleReaderKey = value;
    _sharedPreferences.setString(_linkedBibleReaderStoreKey, value.name);
    notifyListeners();
  }

  List<BibleReader> get certifiedBibleReaderList => _certifiedBibleReaderList;
  bool get isLinked => _linkedBibleReaderKey != BibleReaderKeys.none;
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
}
