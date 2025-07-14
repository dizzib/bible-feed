import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '/model/feed.dart';

enum BibleAppKey { none, youVersion, weDevote }

class BibleAppService {
  static final _bibleApps = {BibleAppKey.youVersion: _YouVersionBibleApp(), BibleAppKey.weDevote: _WeDevoteBibleApp()};

  late BibleAppKey _bibleAppKey = BibleAppKey.youVersion;
  // late BibleAppKey _bibleAppKey = BibleAppKey.weDevote;

  BibleApp get bibleApp => _bibleApps[_bibleAppKey]!;

  set bibleAppKey(BibleAppKey key) {
    _bibleAppKey = key;
  }
}

abstract class BibleApp {
  String get name;
  Uri getDeeplinkUri(Feed f);

  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));
  Future<void> launch(Feed f) async {
    if (await launchUrl(getDeeplinkUri(f))) f.toggleIsChapterRead();
  }
}

@immutable
class _YouVersionBibleApp extends BibleApp {
  @override
  String get name => 'You Version';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('youversion://bible?reference=${f.book.osisParatextAbbrev}.$f._chapter');
}

@immutable
class _WeDevoteBibleApp extends BibleApp {
  @override
  String get name => 'We Devote';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('wdbible://bible/${f.book.osisParatextAbbrev}.$f._chapter');
}
