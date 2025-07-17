import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'feed.dart';

class FeedPersister {
  final Feed feed;
  late final String _storeKeyBookKey;
  late final String _storeKeyChapter;
  late final String _storeKeyDateLastSaved;
  late final String _storeKeyIsChapterRead;

  FeedPersister(this.feed) {
    _storeKeyBookKey = '${feed.readingList.key}.book';
    _storeKeyChapter = '${feed.readingList.key}.chapter';
    _storeKeyDateLastSaved = '${feed.readingList.key}.dateLastSaved';
    _storeKeyIsChapterRead = '${feed.readingList.key}.isChapterRead';
    loadStateOrDefaults();
  }

  void loadStateOrDefaults() {
    feed.book = feed.readingList.getBook(sl<SharedPreferences>().getString(_storeKeyBookKey) ?? feed.readingList[0].key);
    feed.chapter = sl<SharedPreferences>().getInt(_storeKeyChapter) ?? 1;
    feed.isChapterRead = sl<SharedPreferences>().getBool(_storeKeyIsChapterRead) ?? false;
    feed.dateLastSaved = DateTime.tryParse(sl<SharedPreferences>().getString(_storeKeyDateLastSaved) ?? '');
  }

  Future<void> saveState() async {
    feed.dateLastSaved = DateTime.now();
    await sl<SharedPreferences>().setString(_storeKeyBookKey, feed.book.key);
    await sl<SharedPreferences>().setInt(_storeKeyChapter, feed.chapter);
    await sl<SharedPreferences>().setBool(_storeKeyIsChapterRead, feed.isChapterRead);
    await sl<SharedPreferences>().setString(_storeKeyDateLastSaved, feed.dateLastSaved!.toIso8601String());
  }
}
