part of '/model/feed.dart';

class FeedPersisterService {
  String _getStoreKeyBookKey(Feed f) => '${f._readingList.key}.book';
  String _getStoreKeyChapter(Feed f) => '${f._readingList.key}.chapter';
  String _getStoreKeyIsChapterRead(Feed f) => '${f._readingList.key}.isChapterRead';
  String _getStoreKeyDateModified(Feed f) => '${f._readingList.key}.dateModified';

  void loadStateOrDefaults(Feed f) {
    final sp = sl<SharedPreferences>();
    f._book = f._readingList.getBook(sp.getString(_getStoreKeyBookKey(f)) ?? f._readingList[0].key);
    f._chapter = sp.getInt(_getStoreKeyChapter(f)) ?? 1;
    f._isChapterRead = sp.getBool(_getStoreKeyIsChapterRead(f)) ?? false;
    f._dateModified = DateTime.tryParse(sp.getString(_getStoreKeyDateModified(f)) ?? '');
  }

  Future<void> saveState(Feed f) async {
    final sp = sl<SharedPreferences>();
    f._dateModified = DateTime.now();
    await sp.setString(_getStoreKeyBookKey(f), f._book.key);
    await sp.setInt(_getStoreKeyChapter(f), f._chapter);
    await sp.setBool(_getStoreKeyIsChapterRead(f), f._isChapterRead);
    await sp.setString(_getStoreKeyDateModified(f), f._dateModified!.toIso8601String());
  }
}
