import 'package:shared_preferences/shared_preferences.dart';

extension FeedExtensions on SharedPreferences {
  String? getBook(String feedKey) => getString('$feedKey.book');
  int? getChapter(String feedKey) => getInt('$feedKey.chapter');
  DateTime? getDateModified(String feedKey) => DateTime.tryParse(getString('$feedKey.dateModified') ?? '');
  bool? getIsRead(String feedKey) => getBool('$feedKey.isRead');
  int? getVerse(String feedKey) => getInt('$feedKey.verse');

  Future setBook(String feedKey, String bookKey) => setString('$feedKey.book', bookKey);
  Future setChapter(String feedKey, int chapter) => setInt('$feedKey.chapter', chapter);
  Future setDateModified(String feedKey, DateTime? dateModified) =>
      setString('$feedKey.dateModified', dateModified?.toIso8601String() ?? '');
  Future setIsRead(String feedKey, bool isRead) => setBool('$feedKey.isRead', isRead);
  Future setVerse(String feedKey, int verse) => setInt('$feedKey.verse', verse);
}
