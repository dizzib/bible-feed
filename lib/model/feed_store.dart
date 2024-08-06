part of 'feed.dart';

// load/save state of a feed from/to local store
extension StoreExtension on Feed {
  String get _storeKeyBookKey => '${readingList.key}.book';
  String get _storeKeyChapter => '${readingList.key}.chapter';
  String get _storeKeyDateLastSaved => '${readingList.key}.dateLastSaved';
  String get _storeKeyIsChapterRead => '${readingList.key}.isChapterRead';

  void loadState() {
    var bookKey = Store.getString(_storeKeyBookKey);
    if (bookKey == null) return;  // on first run, this will be null
    book = readingList.getBook(bookKey);
    chapter = Store.getInt(_storeKeyChapter)!;
    isChapterRead = Store.getBool(_storeKeyIsChapterRead)!;
    dateLastSaved = DateTime.parse(Store.getString(_storeKeyDateLastSaved)!);
  }

  void saveState() {
    dateLastSaved = DateTime.now();
    Store.setString(_storeKeyBookKey, _book.key);
    Store.setInt(_storeKeyChapter, _chapter);
    Store.setBool(_storeKeyIsChapterRead, _isChapterRead);
    Store.setString(_storeKeyDateLastSaved, _dateLastSaved.toIso8601String());
  }
}
