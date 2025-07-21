part of '/model/feed.dart';

extension Persister on Feed {
  String get _storeKeyBookKey => '${_readingList.key}.book';
  String get _storeKeyChapter => '${_readingList.key}.chapter';
  String get _storeKeyIsChapterRead => '${_readingList.key}.isChapterRead';
  String get _storeKeyDateModified => '${_readingList.key}.dateModified';

  void loadStateOrDefaults() {
    final sp = sl<SharedPreferences>();
    _book = _readingList.getBook(sp.getString(_storeKeyBookKey) ?? _readingList[0].key);
    _chapter = sp.getInt(_storeKeyChapter) ?? 1;
    _isChapterRead = sp.getBool(_storeKeyIsChapterRead) ?? false;
    _dateModified = DateTime.tryParse(sp.getString(_storeKeyDateModified) ?? '');
  }

  Future _saveState() async {
    final sp = sl<SharedPreferences>();
    _dateModified = DateTime.now();
    await sp.setString(_storeKeyBookKey, _book.key);
    await sp.setInt(_storeKeyChapter, _chapter);
    await sp.setBool(_storeKeyIsChapterRead, _isChapterRead);
    await sp.setString(_storeKeyDateModified, _dateModified!.toIso8601String());
  }
}
