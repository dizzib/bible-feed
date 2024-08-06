import '../util/store.dart';
import 'feed.dart';

// load/save state of a feed from/to local store
extension StoreExtension on Feed {
  String get _storeKeyBookKey => '${readingList.key}.book';
  String get _storeKeyChapter => '${readingList.key}.chapter';
  String get _storeKeyDateLastSaved => '${readingList.key}.dateLastSaved';
  String get _storeKeyIsChapterRead => '${readingList.key}.isChapterRead';

  void _assertChapter() {
    assert(chapter > 0);
    assert(chapter <= book.chapterCount);
  }

  void loadState() {
    var bookKey = Store.getString(_storeKeyBookKey);
    if (bookKey == null) return;  // on first run, this will be null
    book = readingList.getBook(bookKey);
    chapter = Store.getInt(_storeKeyChapter)!;
    isChapterRead = Store.getBool(_storeKeyIsChapterRead)!;
    dateLastSaved = DateTime.parse(Store.getString(_storeKeyDateLastSaved)!);
    _assertChapter();
  }

  void saveState() {
    _assertChapter();
    dateLastSaved = DateTime.now();
    Store.setString(_storeKeyBookKey, book.key);
    Store.setInt(_storeKeyChapter, chapter);
    Store.setBool(_storeKeyIsChapterRead, isChapterRead);
    Store.setString(_storeKeyDateLastSaved, dateLastSaved.toIso8601String());
  }
}
