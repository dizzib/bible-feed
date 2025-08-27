import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '/model/book.dart';
import '/model/reading_list.dart';

@immutable
abstract class ReadingLists extends Iterable<ReadingList> {
  List<ReadingList> get items;

  @override
  Iterator<ReadingList> get iterator => items.iterator;
}

@prod
@LazySingleton(as: ReadingLists)
class PghReadingLists extends ReadingLists {
  @override
  get items => [
        ReadingList('gos', 'Gospels', const [
          Book('mat', 'Matthew', 28, {
            26: {1: 'verses_1-35', 36: 'verses_36-75'}
          }),
          Book('mar', 'Mark', 16),
          Book('luk', 'Luke', 24, {
            1: {1: 'verses_1-38', 39: 'verses_39-80'}
          }),
          Book('jhn', 'John', 21, {
            6: {1: 'verses_1-40', 41: 'verses_41-71'}
          }),
        ]),
        ReadingList('pen', 'Pentateuch', const [
          Book('gen', 'Genesis', 50),
          Book('exo', 'Exodus', 40),
          Book('lev', 'Leviticus', 27, {
            13: {1: 'verses_1-28', 29: 'verses_29-59'}
          }),
          Book('num', 'Numbers', 36, {
            7: {1: 'verses_1-47', 48: 'verses_48-89'}
          }),
          Book('deu', 'Deuteronomy', 34, {
            28: {1: 'verses_1-35', 36: 'verses_36-68'}
          }),
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
          Book('1th', '1 Thessalo...', 5),
          Book('2th', '2 Thessalo...', 3),
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
          Book('psa', 'Psalm', 150, {
            119: {
              1: 'ℵ_Aleph__ℶ_Beth',
              17: 'ג_Gimel__ד_Daleth',
              33: 'ה_He__ו_Waw',
              49: 'ז_Zayin__ח_Heth',
              65: 'ט_Teth__י_Yod',
              81: 'כ_Kaph__ל_Lamed',
              97: 'מ_Mem__נ_Nun',
              113: 'ס_Samek__ע_Ayin',
              129: 'פ_Pe__צ_Tsadde',
              145: 'ק_Qoph__ר_Resh',
              161: 'ש_Shin__ת_Tau',
            }
          })
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
          Book('1ki', '1 Kings', 22, {
            8: {1: 'verses_1-32', 33: 'verses_33-66'}
          }),
          Book('2ki', '2 Kings', 25),
          Book('1cr', '1 Chronicles', 29),
          Book('2cr', '2 Chronicles', 36),
          Book('ezr', 'Ezra', 10),
          Book('neh', 'Nehemiah', 13, {
            7: {1: 'verses_1-36', 37: 'verses_37-73'}
          }),
          Book('est', 'Esther', 10),
        ]),
        ReadingList('prp', 'Prophets', const [
          Book('isa', 'Isaiah', 66),
          Book('jer', 'Jeremiah', 52, {
            51: {1: 'verses_1-32', 33: 'verses_33-64'}
          }),
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
          Book('act', 'Acts', 28, {
            7: {1: 'verses_1-29', 30: 'verses_30-60'}
          }),
        ])
      ];
}
