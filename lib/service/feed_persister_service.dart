part of '/model/feed.dart';

class FeedPersisterService {
  String _getStoreKeyBookKey(Feed f) => '${f._readingList.key}.book';
  String _getStoreKeyChapter(Feed f) => '${f._readingList.key}.chapter';
  String _getStoreKeyDateLastSaved(Feed f) => '${f._readingList.key}.dateLastSaved';
  String _getStoreKeyIsChapterRead(Feed f) => '${f._readingList.key}.isChapterRead';

  void loadStateOrDefaults(Feed f) {
    f._book = f._readingList.getBook(sl<SharedPreferences>().getString(_getStoreKeyBookKey(f)) ?? f._readingList[0].key);
    f._chapter = sl<SharedPreferences>().getInt(_getStoreKeyChapter(f)) ?? 1;
    f._isChapterRead = sl<SharedPreferences>().getBool(_getStoreKeyIsChapterRead(f)) ?? false;
    f._dateLastSaved = DateTime.tryParse(sl<SharedPreferences>().getString(_getStoreKeyDateLastSaved(f)) ?? '');
  }

  Future<void> saveState(Feed f) async {
    f._dateLastSaved = DateTime.now();
    await sl<SharedPreferences>().setString(_getStoreKeyBookKey(f), f._book.key);
    await sl<SharedPreferences>().setInt(_getStoreKeyChapter(f), f._chapter);
    await sl<SharedPreferences>().setBool(_getStoreKeyIsChapterRead(f), f._isChapterRead);
    await sl<SharedPreferences>().setString(_getStoreKeyDateLastSaved(f), f._dateLastSaved!.toIso8601String());
  }
}
