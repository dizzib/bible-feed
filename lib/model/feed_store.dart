import '../data/store.dart';
import 'feed.dart';

// load/save state of a feed from/to local store
extension StoreExtension on Feed {
  String get _storeKeyBookKey => '${readingList.key}.book';
  String get _storeKeyChapter => '${readingList.key}.chapter';
  String get _storeKeyDateLastSaved => '${readingList.key}.dateLastSaved';
  String get _storeKeyIsChapterRead => '${readingList.key}.isChapterRead';

  void loadState() {
    var bookKey = Store.getString(_storeKeyBookKey);
    if (bookKey == null) return;  // on first run, this will be null
    current = readingList.getBook(bookKey);
    current.chapter = Store.getInt(_storeKeyChapter)!;
    current.isChapterRead = Store.getBool(_storeKeyIsChapterRead)!;
    dateLastSaved = DateTime.parse(Store.getString(_storeKeyDateLastSaved)!);
  }

  void saveState() {
    dateLastSaved = DateTime.now();
    Store.setString(_storeKeyBookKey, current.key);
    Store.setInt(_storeKeyChapter, current.chapter);
    Store.setBool(_storeKeyIsChapterRead, current.isChapterRead);
    Store.setString(_storeKeyDateLastSaved, dateLastSaved.toIso8601String());
  }
}
