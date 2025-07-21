import '/model/book.dart';
import '/model/reading_list.dart';

class ReadingLists {
  final _items = [
    ReadingList('gos', 'Gospels', const [
      Book('mat', 'Matthew', 28),
      Book('mar', 'Mark', 16),
      Book('luk', 'Luke', 24),
      Book('jhn', 'John', 21),
    ]),
    ReadingList('pen', 'Pentateuch', const [
      Book('gen', 'Genesis', 50),
      Book('exo', 'Exodus', 40),
      Book('lev', 'Leviticus', 27),
      Book('num', 'Numbers', 36),
      Book('deu', 'Deuteronomy', 34),
    ]),
    ReadingList('ep1', 'Epistles I', const [
      Book('rom', 'Romans', 16),
      Book('1co', '1 Corinthians', 16),
      Book('2co', '2 Corinthians', 13),
      Book('gal', 'Galatians', 6),
      Book('eph', 'Ephesians', 6),
      Book('php', 'Philippians', 4),
      Book('col', 'Colossians', 4),
      Book('heb', 'Hebrews', 13),
    ]),
    ReadingList('ep2', 'Epistles II', const [
      Book('1th', '1 Thessalonians', 5),
      Book('2th', '2 Thessalonians', 3),
      Book('1ti', '1 Timothy', 6),
      Book('2ti', '2 Timothy', 4),
      Book('tit', 'Titus', 3),
      Book('phm', 'Philemon', 1),
      Book('jam', 'James', 5),
      Book('1pe', '1 Peter', 5),
      Book('2pe', '2 Peter', 3),
      Book('1jn', '1 John', 5),
      Book('2jn', '2 John', 1),
      Book('3jn', '3 John', 1),
      Book('jud', 'Jude', 1),
      Book('rev', 'Revelation', 22),
    ]),
    ReadingList('wis', 'Wisdom', const [
      Book('job', 'Job', 42),
      Book('ecc', 'Ecclesiastes', 12),
      Book('sos', 'Song of Solomon', 8),
    ]),
    ReadingList('psa', 'Psalms', const [
      Book('psa', 'Psalm', 150),
    ]),
    ReadingList('prv', 'Proverbs', const [
      Book('prv', 'Proverbs', 31),
    ]),
    ReadingList('his', 'History', const [
      Book('jos', 'Joshua', 24),
      Book('jdg', 'Judges', 21),
      Book('rth', 'Ruth', 4),
      Book('1sa', '1 Samuel', 31),
      Book('2sa', '2 Samuel', 24),
      Book('1ki', '1 Kings', 22),
      Book('2ki', '2 Kings', 25),
      Book('1cr', '1 Chronicles', 29),
      Book('2cr', '2 Chronicles', 36),
      Book('ezr', 'Ezra', 10),
      Book('neh', 'Nehemiah', 13),
      Book('est', 'Esther', 10),
    ]),
    ReadingList('prp', 'Prophets', const [
      Book('isa', 'Isaiah', 66),
      Book('jer', 'Jeremiah', 52),
      Book('lam', 'Lamentations', 5),
      Book('eze', 'Ezekiel', 48),
      Book('dan', 'Daniel', 12),
      Book('hos', 'Hosea', 14),
      Book('joe', 'Joel', 3),
      Book('amo', 'Amos', 9),
      Book('obd', 'Obadiah', 1),
      Book('jon', 'Jonah', 4),
      Book('mic', 'Micah', 7),
      Book('nah', 'Nahum', 3),
      Book('hab', 'Habakkuk', 3),
      Book('zep', 'Zephaniah', 3),
      Book('hag', 'Haggai', 2),
      Book('zec', 'Zechariah', 14),
      Book('mal', 'Malachi', 4),
    ]),
    ReadingList('act', 'Acts', const [
      Book('act', 'Acts', 28),
    ])
  ];

  List<ReadingList> get items => _items;
}
