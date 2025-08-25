import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/feed.dart';

@lazySingleton
class VerseScopeService extends ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  VerseScopeService(this._sharedPreferences);

  static const _storeKey = 'isEnabledVerseScopes';

  Map<int, String>? _verseScopeMap(Feed f) => f.state.book.verseScopeMaps?[f.state.chapter];

  bool get isEnabled => _sharedPreferences.getBool(_storeKey) ?? true;

  set isEnabled(bool value) {
    _sharedPreferences.setBool(_storeKey, value);
    notifyListeners();
  }

  int nextVerse(Feed f) {
    if (!isEnabled) return 1;
    final vsm = _verseScopeMap(f);
    if (vsm == null) return 1;
    final verses = vsm.keys.toList();
    final index = verses.indexOf(f.verse) + 1;
    if (index == verses.length) return 1;
    return verses[index];
  }

  String verseScopeName(Feed f) {
    if (!isEnabled) return '';
    final vsm = _verseScopeMap(f);
    if (vsm == null) return '';
    return vsm[f.verse]!.replaceAll('_', String.fromCharCode(0x00A0));
  }
}
