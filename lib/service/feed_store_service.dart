import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/extension/shared_preferences.dart';
import '/model/feed.dart';
import '/model/reading_list.dart';

@lazySingleton
class FeedStoreService {
  final SharedPreferences _sharedPreferences;

  FeedStoreService(this._sharedPreferences);

  FeedState loadState(ReadingList readingList) {
    return FeedState(
      book: readingList.getBook(_sharedPreferences.getBook(readingList.key) ?? readingList[0].key),
      chapter: _sharedPreferences.getChapter(readingList.key) ?? 1,
      dateModified: _sharedPreferences.getDateModified(readingList.key),
      isRead: _sharedPreferences.getIsRead(readingList.key) ?? false,
      verse: _sharedPreferences.getVerse(readingList.key) ?? 1,
    );
  }

  Future saveState(Feed f) async {
    await _sharedPreferences.setBook(f.readingList.key, f.state.book.key);
    await _sharedPreferences.setChapter(f.readingList.key, f.state.chapter);
    await _sharedPreferences.setDateModified(f.readingList.key, f.state.dateModified);
    await _sharedPreferences.setIsRead(f.readingList.key, f.state.isRead);
    await _sharedPreferences.setVerse(f.readingList.key, f.state.verse);
  }
}
