part of '/model/feed.dart';

class FeedPersisterService {
  String _getStoreKeyBookKey(Feed f) => '${f._readingList.key}.book';
  String _getStoreKeyChapter(Feed f) => '${f._readingList.key}.chapter';
  String _getStoreKeyIsChapterRead(Feed f) => '${f._readingList.key}.isChapterRead';
  String _getStoreKeyDateModified(Feed f) => '${f._readingList.key}.dateModified';

  void loadStateOrDefaults(Feed f) {
    f._book = f._readingList.getBook(sl<SharedPreferences>().getString(_getStoreKeyBookKey(f)) ?? f._readingList[0].key);
    f._chapter = sl<SharedPreferences>().getInt(_getStoreKeyChapter(f)) ?? 1;
    f._isChapterRead = sl<SharedPreferences>().getBool(_getStoreKeyIsChapterRead(f)) ?? false;
    f._dateModified = DateTime.tryParse(sl<SharedPreferences>().getString(_getStoreKeyDateModified(f)) ?? '');
  }

  Future<void> saveState(Feed f) async {
    f._dateModified = DateTime.now();
    await sl<SharedPreferences>().setString(_getStoreKeyBookKey(f), f._book.key);
    await sl<SharedPreferences>().setInt(_getStoreKeyChapter(f), f._chapter);
    await sl<SharedPreferences>().setBool(_getStoreKeyIsChapterRead(f), f._isChapterRead);
    await sl<SharedPreferences>().setString(_getStoreKeyDateModified(f), f._dateModified!.toIso8601String());
  }
}
