part of '/model/feed.dart';

extension Persister on Feed {
  String get _storeKeyVerse => '${_readingList.key}.verse';

  void loadStateOrDefaults() {
    _verse = _sharedPreferences.getInt(_storeKeyVerse) ?? 1;
  }

  Future _saveState() async {
    await _sharedPreferences.setInt(_storeKeyVerse, _verse);
  }
}
