import 'package:flutter/foundation.dart';
import '../util/store.dart';
import 'feed.dart';

class FeedPersister with ChangeNotifier {
  final Feed feed;

  FeedPersister(this.feed) {
    loadStateOrDefaults();
  }

  String get _storeKeyBookKey => '${feed.readingList.key}.book';
  String get _storeKeyChapter => '${feed.readingList.key}.chapter';
  String get _storeKeyDateLastSaved => '${feed.readingList.key}.dateLastSaved';
  String get _storeKeyIsChapterRead => '${feed.readingList.key}.isChapterRead';

  void loadStateOrDefaults() {
    feed.book = feed.readingList.getBook(Store.getString(_storeKeyBookKey) ?? feed.readingList[0].key);
    feed.chapter = Store.getInt(_storeKeyChapter) ?? 1;
    feed.isChapterRead = Store.getBool(_storeKeyIsChapterRead) ?? false;
    feed.dateLastSaved = DateTime.tryParse(Store.getString(_storeKeyDateLastSaved) ?? '');
    notifyListeners();
  }

  void saveState() {
    feed.dateLastSaved = DateTime.now();
    Store.setString(_storeKeyBookKey, feed.book.key);
    Store.setInt(_storeKeyChapter, feed.chapter);
    Store.setBool(_storeKeyIsChapterRead, feed.isChapterRead);
    Store.setString(_storeKeyDateLastSaved, feed.dateLastSaved!.toIso8601String());
    notifyListeners();
  }
}
