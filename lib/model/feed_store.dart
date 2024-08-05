import '../data/store.dart';
import 'feed.dart';

extension StoreExtension on Feed {
  String get _storeKeyBookKey => '${readingList.key}.book';
  String get _storeKeyChapter => '${readingList.key}.chapter';
  String get _storeKeyDateLastSaved => '${readingList.key}.dateLastSaved';
  String get _storeKeyIsChapterRead => '${readingList.key}.isChapterRead';

  void loadState() {
    var bookKey = Store.getString(_storeKeyBookKey);
    if (bookKey == null) return;  // on first run, this will be null
    readingList.current = readingList.getBook(bookKey);
    readingList.current.chapter = Store.getInt(_storeKeyChapter)!;
    readingList.current.isChapterRead = Store.getBool(_storeKeyIsChapterRead)!;
    dateLastSaved = DateTime.parse(Store.getString(_storeKeyDateLastSaved)!);
  }

  void saveState() {
    dateLastSaved = DateTime.now();
    Store.setString(_storeKeyBookKey, readingList.current.key);
    Store.setInt(_storeKeyChapter, readingList.current.chapter);
    Store.setBool(_storeKeyIsChapterRead, readingList.current.isChapterRead);
    Store.setString(_storeKeyDateLastSaved, dateLastSaved.toIso8601String());
  }
}
