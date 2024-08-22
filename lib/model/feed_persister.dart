import 'package:flutter/foundation.dart';
import '../util/store.dart';
import 'feed.dart';

class FeedPersister with ChangeNotifier {
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
    feed.book = feed.readingList.getBook(Store.getString(_storeKeyBookKey) ?? feed.readingList[0].key);
    feed.chapter = Store.getInt(_storeKeyChapter) ?? 1;
    feed.isChapterRead = Store.getBool(_storeKeyIsChapterRead) ?? false;
    feed.dateLastSaved = DateTime.tryParse(Store.getString(_storeKeyDateLastSaved) ?? '');
    notifyListeners();
  }

  Future<void> saveState() async {
    feed.dateLastSaved = DateTime.now();
    await Store.setString(_storeKeyBookKey, feed.book.key);
    await Store.setInt(_storeKeyChapter, feed.chapter);
    await Store.setBool(_storeKeyIsChapterRead, feed.isChapterRead);
    await Store.setString(_storeKeyDateLastSaved, feed.dateLastSaved!.toIso8601String());
    notifyListeners();
  }
}
