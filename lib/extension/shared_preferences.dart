import 'package:shared_preferences/shared_preferences.dart';

extension FeedExtensions on SharedPreferences {
  String? getBook(String feedKey) => getString('$feedKey.book');
  int? getChapter(String feedKey) => getInt('$feedKey.chapter');
  DateTime? getDateModified(String feedKey) => DateTime.tryParse(getString('$feedKey.dateModified') ?? '');
  bool? getIsRead(String feedKey) => getBool('$feedKey.isRead');
  int? getVerse(String feedKey) => getInt('$feedKey.verse');
}
