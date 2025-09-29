import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/feed.dart';
import '/model/reading_list.dart';

@lazySingleton
class FeedStoreService {
  final SharedPreferences _sharedPreferences;

  FeedStoreService(this._sharedPreferences);

  FeedState loadState(ReadingList readingList) {
    const defaultChapter = 1;
    const defaultVerse = 1;

    return FeedState(
      book: readingList.getBook(_sharedPreferences.getString('${readingList.key}.book') ?? readingList[0].key),
      chapter: _sharedPreferences.getInt('${readingList.key}.chapter') ?? defaultChapter,
      verse: _sharedPreferences.getInt('${readingList.key}.verse') ?? defaultVerse,
      isRead: _sharedPreferences.getBool('${readingList.key}.isRead') ?? false,
      dateModified: DateTime.tryParse(_sharedPreferences.getString('${readingList.key}.dateModified') ?? ''),
    );
  }

  Future saveState(ReadingList readingList, FeedState state) async {
    await _sharedPreferences.setString('${readingList.key}.book', state.book.key);
    await _sharedPreferences.setInt('${readingList.key}.chapter', state.chapter);
    await _sharedPreferences.setInt('${readingList.key}.verse', state.verse);
    await _sharedPreferences.setBool('${readingList.key}.isRead', state.isRead);
    await _sharedPreferences.setString('${readingList.key}.dateModified', state.dateModified?.toIso8601String() ?? '');
  }
}
