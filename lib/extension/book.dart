import '/model/book.dart';

// see https://wiki.crosswire.org/OSIS_Book_Abbreviations
extension OsisBookAbbreviations on Book {
  String get osisParatextAbbrev =>
      const {
        'mar': 'mrk',
        'jam': 'jas',
        'rth': 'rut',
        'sos': 'sng',
        'prv': 'pro',
        '1cr': '1ch',
        '2cr': '2ch',
        'eze': 'ezk',
        'joe': 'jol',
        'odb': 'oba',
        'nah': 'nam',
      }[key] ??
      key;
}
