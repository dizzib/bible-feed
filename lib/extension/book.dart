import '/model/book.dart';

// see https://wiki.crosswire.org/OSIS_Book_Abbreviations
extension OsisBookAbbreviations on Book {
  String get osisParatextAbbrev =>
      const {
        '1cr': '1ch',
        '2cr': '2ch',
        'eze': 'ezk',
        'jam': 'jas',
        'joe': 'jol',
        'mar': 'mrk',
        'nah': 'nam',
        'odb': 'oba',
        'prv': 'pro',
        'rth': 'rut',
        'sos': 'sng',
      }[key] ??
      key;
}
