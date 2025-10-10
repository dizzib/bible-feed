import 'package:bible_feed/model/bible_reader_key.dart';
import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_reader_type.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/book_key_externaliser.dart';
import 'package:bible_feed/model/reading_list.dart';
import 'package:bible_feed/model/url_template.dart';

const b0 = Book('b0', 'Book 0', 1);
const b1 = Book('b1', 'Book 1', 3);
const b2 = Book('b2', 'Book 2', 5);

final rl0 = ReadingList('rl0', 'Reading List 0', const [b0]);
final rl1 = ReadingList('rl1', 'Reading List 1', const [b0, b1]);

final noneBibleReader = BibleReader(
  key: BibleReaderKey.none,
  type: BibleReaderType.none,
  name: '',
  certifiedPlatforms: const [],
  urlTemplate: UrlTemplate(''),
);

final blbBibleReader = BibleReader(
  key: BibleReaderKey.blueLetterApp,
  type: BibleReaderType.app,
  name: 'name',
  certifiedPlatforms: const [],
  urlTemplate: UrlTemplate.byPlatform(android: 'blb://android/BOOK/CHAPTER', iOS: 'blb://ios/BOOK/CHAPTER'),
  urlVersePath: '/VERSE',
  bookKeyExternaliser: BookKeyExternaliser.blueLetter,
);
