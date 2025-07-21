import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/reading_list.dart';
import 'mock_book.dart';

var l0 = ReadingList('l0', 'Reading List 0', [b0]);
var l1 = ReadingList('l1', 'Reading List 1', [b0, b1]);
var l2 = ReadingList('l2', 'Reading List 2', [b0, b1, b2]);

var f0 = Feed(l0);
var f1 = Feed(l1);
var f2 = Feed(l2);
