part of '/model/feed.dart';

extension Persister on Feed {
  String get _storeKeyChapter => '${_readingList.key}.chapter';
  String get _storeKeyDateModified => '${_readingList.key}.dateModified';
  String get _storeKeyIsRead => '${_readingList.key}.isRead';
  String get _storeKeyVerse => '${_readingList.key}.verse';

  void loadStateOrDefaults() {
    _chapter = _sharedPreferences.getInt(_storeKeyChapter) ?? 1;
    _dateModified = DateTime.tryParse(_sharedPreferences.getString(_storeKeyDateModified) ?? '');
    _isRead = _sharedPreferences.getBool(_storeKeyIsRead) ?? false;
    _verse = _sharedPreferences.getInt(_storeKeyVerse) ?? 1;
  }

  Future _saveState() async {
    _dateModified = DateTime.now();
    await _sharedPreferences.setInt(_storeKeyChapter, _chapter);
    await _sharedPreferences.setBool(_storeKeyIsRead, _isRead);
    await _sharedPreferences.setString(_storeKeyDateModified, _dateModified!.toIso8601String());
    await _sharedPreferences.setInt(_storeKeyVerse, _verse);
  }
}
