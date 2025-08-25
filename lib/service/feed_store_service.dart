import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/extension/shared_preferences.dart';
import '/model/feed.dart';
import '/model/reading_list.dart';

@lazySingleton
class FeedStoreService {
  final SharedPreferences _sharedPreferences;

  FeedStoreService(this._sharedPreferences);

  String _getBookStoreKey(readingList) => '${readingList.key}.book';
  String _getChapterStoreKey(readingList) => '${readingList.key}.chapter';
  String _getDateModifiedStoreKey(readingList) => '${readingList.key}.dateModified';
  String _getIsReadStoreKey(readingList) => '${readingList.key}.isRead';
  String _getVerseStoreKey(readingList) => '${readingList.key}.verse';

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
    await _sharedPreferences.setString(_getBookStoreKey(f.readingList), f.state.book.key);
    await _sharedPreferences.setInt(_getChapterStoreKey(f.readingList), f.state.chapter);
    await _sharedPreferences.setString(
        _getDateModifiedStoreKey(f.readingList), f.state.dateModified!.toIso8601String());
    await _sharedPreferences.setBool(_getIsReadStoreKey(f.readingList), f.state.isRead);
    await _sharedPreferences.setInt(_getVerseStoreKey(f.readingList), f.state.verse);
  }
}
