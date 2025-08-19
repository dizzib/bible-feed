part of '/model/feed.dart';

extension Persister on Feed {
  String get _storeKeyBookKey => '${_readingList.key}.book';
  String get _storeKeyChapter => '${_readingList.key}.chapter';
  String get _storeKeyDateModified => '${_readingList.key}.dateModified';
  String get _storeKeyIsRead => '${_readingList.key}.isRead';
  String get _storeKeyVerse => '${_readingList.key}.verse';

  void loadStateOrDefaults() {
    final sp = sl<SharedPreferences>();
    _book = _readingList.getBook(sp.getString(_storeKeyBookKey) ?? _readingList[0].key);
    _chapter = sp.getInt(_storeKeyChapter) ?? 1;
    _dateModified = DateTime.tryParse(sp.getString(_storeKeyDateModified) ?? '');
    _isRead = sp.getBool(_storeKeyIsRead) ?? false;
    _verse = sp.getInt(_storeKeyVerse) ?? 1;
  }

  Future _saveState() async {
    final sp = sl<SharedPreferences>();
    _dateModified = DateTime.now();
    await sp.setString(_storeKeyBookKey, _book.key);
    await sp.setInt(_storeKeyChapter, _chapter);
    await sp.setBool(_storeKeyIsRead, _isRead);
    await sp.setString(_storeKeyDateModified, _dateModified!.toIso8601String());
    await sp.setInt(_storeKeyVerse, _verse);
  }
}
