import 'package:shared_preferences/shared_preferences.dart';

extension FeedExtensions on SharedPreferences {
  String? getBook(String key) => getString('$key.book');
  int? getChapter(String key) => getInt('$key.chapter');
  DateTime? getDateModified(String key) =>
      DateTime.tryParse(getString('$key.dateModified') ?? '');
  bool? getIsRead(String key) => getBool('$key.isRead');
  int? getVerse(String key) => getInt('$key.verse');

  Future setBook(String key, String bookKey) => setString('$key.book', bookKey);
  Future setChapter(String key, int chapter) => setInt('$key.chapter', chapter);
  Future setDateModified(String key, DateTime? dateModified) =>
      setString('$key.dateModified', dateModified?.toIso8601String() ?? '');
  Future setIsRead(String key, bool isRead) => setBool('$key.isRead', isRead);
  Future setVerse(String key, int verse) => setInt('$key.verse', verse);
}
