part of 'feed.dart';

extension StateProperties on Feed {
  Book get book => _book;
  int get chapter => _chapter;
  bool get isChapterRead => _isChapterRead;
  DateTime get dateLastSaved => _dateLastSaved;

  @visibleForTesting set book(Book b) => _book = b;
  @visibleForTesting set chapter(int chapter) { _assertChapter(); _chapter = chapter; }
  @visibleForTesting set isChapterRead(bool val) => _isChapterRead = val;
  @visibleForTesting set dateLastSaved(DateTime d) => _dateLastSaved = d;

  void _assertChapter() { assert(chapter > 0); assert(chapter <= book.chapterCount); }
}

extension StatePersistance on Feed {
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
    Store.setString(_storeKeyBookKey, book.key);
    Store.setInt(_storeKeyChapter, chapter);
    Store.setBool(_storeKeyIsChapterRead, isChapterRead);
    Store.setString(_storeKeyDateLastSaved, dateLastSaved.toIso8601String());
  }
}
