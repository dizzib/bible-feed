import '../model/bible_app.dart';

enum BibleAppKey { none, youVersion, weDevote }

class BibleAppService {
  static final _bibleApps = {BibleAppKey.youVersion: YouVersionBibleApp(), BibleAppKey.weDevote: WeDevoteBibleApp()};

  late BibleAppKey _bibleAppKey = BibleAppKey.youVersion;
  // late BibleAppKey _bibleAppKey = BibleAppKey.weDevote;

  BibleApp get bibleApp => _bibleApps[_bibleAppKey]!;

  set bibleAppKey(BibleAppKey key) {
    _bibleAppKey = key;
  }
}
