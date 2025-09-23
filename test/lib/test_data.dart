import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/reading_list.dart';

const b0 = Book('b0', 'Book 0', 1);
const b1 = Book('b1', 'Book 1', 3);
const b2 = Book('b2', 'Book 2', 5);

final rl0 = ReadingList('rl0', 'Reading List 0', const [b0]);
final rl1 = ReadingList('rl1', 'Reading List 1', const [b0, b1]);
