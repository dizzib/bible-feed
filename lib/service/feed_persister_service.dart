import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import '/model/feed.dart';

class FeedPersisterService {
  String _getStoreKeyBookKey(Feed f) => '${f.readingList.key}.book';
  String _getStoreKeyChapter(Feed f) => '${f.readingList.key}.chapter';
  String _getStoreKeyDateLastSaved(Feed f) => '${f.readingList.key}.dateLastSaved';
  String _getStoreKeyIsChapterRead(Feed f) => '${f.readingList.key}.isChapterRead';

  void loadStateOrDefaults(Feed f) {
    f.book = f.readingList.getBook(sl<SharedPreferences>().getString(_getStoreKeyBookKey(f)) ?? f.readingList[0].key);
    f.chapter = sl<SharedPreferences>().getInt(_getStoreKeyChapter(f)) ?? 1;
    f.isChapterRead = sl<SharedPreferences>().getBool(_getStoreKeyIsChapterRead(f)) ?? false;
    f.dateLastSaved = DateTime.tryParse(sl<SharedPreferences>().getString(_getStoreKeyDateLastSaved(f)) ?? '');
  }

  Future<void> saveState(Feed f) async {
    f.dateLastSaved = DateTime.now();
    await sl<SharedPreferences>().setString(_getStoreKeyBookKey(f), f.book.key);
    await sl<SharedPreferences>().setInt(_getStoreKeyChapter(f), f.chapter);
    await sl<SharedPreferences>().setBool(_getStoreKeyIsChapterRead(f), f.isChapterRead);
    await sl<SharedPreferences>().setString(_getStoreKeyDateLastSaved(f), f.dateLastSaved!.toIso8601String());
  }
}
