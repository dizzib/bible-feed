import 'package:dartx/dartx.dart';
import '/model/bible_reader.dart';

enum BibleReaderKey {
  none,
  andBible,
  bibleHub,
  blueLetter,
  lifeBible,
  logosBible,
  oliveTreeApp,
  youVersionApp,
  weDevoteApp,
}

class BibleReaders {
  BibleReaders() {
    certified = items.filter((entry) => entry.value.isCertifiedForThisPlatform);
  }

  final items = {
    BibleReaderKey.none: NoBibleReader(),
    BibleReaderKey.andBible: AndBibleReader(),
    BibleReaderKey.blueLetter: BlueLetterBibleReader(),
    BibleReaderKey.bibleHub: BibleHubBibleReader(),
    BibleReaderKey.lifeBible: LifeBibleReader(),
    BibleReaderKey.logosBible: LogosBibleReader(),
    BibleReaderKey.oliveTreeApp: OliveTreeBibleReader(),
    BibleReaderKey.weDevoteApp: WeDevoteBibleReader(),
    BibleReaderKey.youVersionApp: YouVersionBibleReader(),
  };
  late final Map<BibleReaderKey, BibleReader> certified;

  List<BibleReader> get certifiedList => certified.values.toList();
}
