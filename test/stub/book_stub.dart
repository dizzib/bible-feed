import 'package:bible_feed/model/book.dart';

var b0 = const Book('b0', 'Book 0', 5);
var b1 = const Book('b1', 'Book 1', 3);
var b2 = const Book('b2', 'Book 2', 2, {
  2: {
    1: 'split 1',
    7: 'split 2',
  },
});
