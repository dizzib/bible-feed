part of 'feed.dart';

class FeedState {
  Book _book;
  int _chapter;
  DateTime? _dateModified;
  bool _isRead;
  int _verse;

  FeedState({required Book book, required int chapter, DateTime? dateModified, required bool isRead, int verse = 1})
      : _book = book,
        _chapter = chapter,
        _dateModified = dateModified,
        _isRead = isRead,
        _verse = verse;

  Book get book => _book;
  int get chapter => _chapter;
  DateTime? get dateModified => _dateModified;
  bool get isRead => _isRead;
  int get verse => _verse;
}
