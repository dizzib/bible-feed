part of '/model/feed.dart';

extension Persister on Feed {
  String get _storeKeyIsRead => '${_readingList.key}.isRead';
  String get _storeKeyVerse => '${_readingList.key}.verse';

  void loadStateOrDefaults() {
    _isRead = _sharedPreferences.getBool(_storeKeyIsRead) ?? false;
    _verse = _sharedPreferences.getInt(_storeKeyVerse) ?? 1;
  }

  Future _saveState() async {
    await _sharedPreferences.setBool(_storeKeyIsRead, _isRead);
    await _sharedPreferences.setInt(_storeKeyVerse, _verse);
  }
}
