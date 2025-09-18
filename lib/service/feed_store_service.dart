import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/feed.dart';
import '/model/reading_list.dart';
import 'shared_preferences_extension.dart';

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

  Future saveState(ReadingList readingList, FeedState state) async {
    await _sharedPreferences.setBook(readingList.key, state.book.key);
    await _sharedPreferences.setChapter(readingList.key, state.chapter);
    await _sharedPreferences.setDateModified(readingList.key, state.dateModified);
    await _sharedPreferences.setIsRead(readingList.key, state.isRead);
    await _sharedPreferences.setVerse(readingList.key, state.verse);
  }
}
