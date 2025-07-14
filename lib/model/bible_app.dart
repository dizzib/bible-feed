import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '/model/feed.dart';

abstract class BibleApp {
  String get name;
  Uri getDeeplinkUri(Feed f);

  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));
  Future<void> launch(Feed f) async {
    if (await launchUrl(getDeeplinkUri(f))) f.toggleIsChapterRead();
  }
}

@immutable
class YouVersionBibleApp extends BibleApp {
  @override
  String get name => 'You Version';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('youversion://bible?reference=${f.book.osisParatextAbbrev}.$f._chapter');
}

@immutable
class WeDevoteBibleApp extends BibleApp {
  @override
  String get name => 'We Devote';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('wdbible://bible/${f.book.osisParatextAbbrev}.$f._chapter');
}
