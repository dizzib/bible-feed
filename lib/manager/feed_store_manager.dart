import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import '../model/reading_list.dart';
import '../service/store_service.dart';

@lazySingleton
class FeedStoreManager {
  final StoreService _storeService;

  FeedStoreManager(this._storeService);

  Feed load(ReadingList readingList) {
    const defaultChapter = 1;
    const defaultVerse = 1;

    return Feed(
      bookKey: _storeService.get('${readingList.key}.book') ?? readingList[0].key,
      chapter: _storeService.get('${readingList.key}.chapter') ?? defaultChapter,
      verse: _storeService.get('${readingList.key}.verse') ?? defaultVerse,
      isRead: _storeService.get('${readingList.key}.isRead') ?? false,
      dateModified: _storeService.get('${readingList.key}.dateModified'),
    );
  }

  Future<void> save(ReadingList readingList, Feed state) async {
    await _storeService.set('${readingList.key}.book', state.bookKey);
    await _storeService.set('${readingList.key}.chapter', state.chapter);
    await _storeService.set('${readingList.key}.verse', state.verse);
    await _storeService.set('${readingList.key}.isRead', state.isRead);
    await _storeService.set('${readingList.key}.dateModified', state.dateModified);
  }
}
