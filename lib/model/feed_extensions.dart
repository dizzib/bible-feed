part of 'feed.dart';

extension StateProperties on Feed {
  Book get book => _book;
  int get chapter => _chapter;
  bool get isChapterRead => _isChapterRead;
  DateTime? get dateLastSaved => _dateLastSaved;

  @visibleForTesting set book(Book b) => _book = b;
  @visibleForTesting set chapter(int c) { assert(c > 0); assert(c <= book.chapterCount); _chapter = c; }
  @visibleForTesting set isChapterRead(bool val) => _isChapterRead = val;
  @visibleForTesting set dateLastSaved(DateTime? d) => _dateLastSaved = d;
}

extension StatePersistance on Feed {
  String get _storeKeyBookKey => '${readingList.key}.book';
  String get _storeKeyChapter => '${readingList.key}.chapter';
  String get _storeKeyDateLastSaved => '${readingList.key}.dateLastSaved';
  String get _storeKeyIsChapterRead => '${readingList.key}.isChapterRead';

  void _loadStateOrDefaults() {
    book = readingList.getBook(Store.getString(_storeKeyBookKey) ?? readingList[0].key);
    chapter = Store.getInt(_storeKeyChapter) ?? 1;
    isChapterRead = Store.getBool(_storeKeyIsChapterRead) ?? false;
    dateLastSaved = DateTime.tryParse(Store.getString(_storeKeyDateLastSaved) ?? '');
  }

  void _saveState() {
    dateLastSaved = DateTime.now();
    Store.setString(_storeKeyBookKey, book.key);
    Store.setInt(_storeKeyChapter, chapter);
    Store.setBool(_storeKeyIsChapterRead, isChapterRead);
    Store.setString(_storeKeyDateLastSaved, dateLastSaved!.toIso8601String());
  }
}
