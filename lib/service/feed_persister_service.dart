part of '/model/feed.dart';

class FeedPersisterService {
  final _sp = sl<SharedPreferences>();
  String _getStoreKeyBookKey(Feed f) => '${f._readingList.key}.book';
  String _getStoreKeyChapter(Feed f) => '${f._readingList.key}.chapter';
  String _getStoreKeyIsChapterRead(Feed f) => '${f._readingList.key}.isChapterRead';
  String _getStoreKeyDateModified(Feed f) => '${f._readingList.key}.dateModified';

  void loadStateOrDefaults(Feed f) {
    f._book = f._readingList.getBook(_sp.getString(_getStoreKeyBookKey(f)) ?? f._readingList[0].key);
    f._chapter = _sp.getInt(_getStoreKeyChapter(f)) ?? 1;
    f._isChapterRead = _sp.getBool(_getStoreKeyIsChapterRead(f)) ?? false;
    f._dateModified = DateTime.tryParse(_sp.getString(_getStoreKeyDateModified(f)) ?? '');
  }

  Future<void> saveState(Feed f) async {
    f._dateModified = DateTime.now();
    await _sp.setString(_getStoreKeyBookKey(f), f._book.key);
    await _sp.setInt(_getStoreKeyChapter(f), f._chapter);
    await _sp.setBool(_getStoreKeyIsChapterRead(f), f._isChapterRead);
    await _sp.setString(_getStoreKeyDateModified(f), f._dateModified!.toIso8601String());
  }
}
