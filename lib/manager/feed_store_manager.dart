import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import '../model/reading_list.dart';
import '../service/store_service.dart';

@lazySingleton
class FeedStoreManager {
  final StoreService _storeService;

  FeedStoreManager(this._storeService);

  FeedState loadState(ReadingList readingList) {
    const defaultChapter = 1;
    const defaultVerse = 1;

    return FeedState(
      book: readingList.getBook(_storeService.getString('${readingList.key}.book') ?? readingList[0].key),
      chapter: _storeService.getInt('${readingList.key}.chapter') ?? defaultChapter,
      verse: _storeService.getInt('${readingList.key}.verse') ?? defaultVerse,
      isRead: _storeService.getBool('${readingList.key}.isRead') ?? false,
      dateModified: DateTime.tryParse(_storeService.getString('${readingList.key}.dateModified') ?? ''),
    );
  }

  Future saveState(ReadingList readingList, FeedState state) async {
    await _storeService.setString('${readingList.key}.book', state.book.key);
    await _storeService.setInt('${readingList.key}.chapter', state.chapter);
    await _storeService.setInt('${readingList.key}.verse', state.verse);
    await _storeService.setBool('${readingList.key}.isRead', state.isRead);
    await _storeService.setString('${readingList.key}.dateModified', state.dateModified?.toIso8601String() ?? '');
  }
}
