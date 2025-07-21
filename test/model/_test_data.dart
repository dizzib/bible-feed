import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/reading_list.dart';

var b0 = const Book('b0', 'Book 0', 5);
var b1 = const Book('b1', 'Book 1', 3);
var b2 = const Book('b2', 'Book 2', 2);

var l0 = ReadingList('l0', 'Reading List 0', [b0]);
var l1 = ReadingList('l1', 'Reading List 1', [b0, b1]);
var l2 = ReadingList('l2', 'Reading List 2', [b0, b1, b2]);

var f0 = Feed(l0);
var f1 = Feed(l1);
var f2 = Feed(l2);
