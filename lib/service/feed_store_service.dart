import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      book: readingList.getBook(_sharedPreferences.getString(_getBookStoreKey(readingList)) ?? readingList[0].key),
      chapter: _sharedPreferences.getInt(_getChapterStoreKey(readingList)) ?? 1,
      dateModified: DateTime.tryParse(_sharedPreferences.getString(_getDateModifiedStoreKey(readingList)) ?? ''),
      isRead: _sharedPreferences.getBool(_getIsReadStoreKey(readingList)) ?? false,
      verse: _sharedPreferences.getInt(_getVerseStoreKey(readingList)) ?? 1,
    );
  }

  Future saveState(ReadingList readingList, FeedState feedState) async {
    await _sharedPreferences.setString(_getBookStoreKey(readingList), feedState.book.key);
    await _sharedPreferences.setInt(_getChapterStoreKey(readingList), feedState.chapter);
    await _sharedPreferences.setString(
        _getDateModifiedStoreKey(readingList), feedState.dateModified!.toIso8601String());
    await _sharedPreferences.setBool(_getIsReadStoreKey(readingList), feedState.isRead);
    await _sharedPreferences.setInt(_getVerseStoreKey(readingList), feedState.verse);
  }
}
