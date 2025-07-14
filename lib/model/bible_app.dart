import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';
import '/model/feed.dart';
import '/model/feeds.dart';

abstract class BibleApp {
  String get name;
  bool get isAlwaysSelectable => false;
  Uri getDeeplinkUri(Feed f);

  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));
  Future<void> launch(Feed f) async {
    if (await launchUrl(getDeeplinkUri(f))) f.toggleIsChapterRead();
  }

  Future<bool> isSelectable() async =>
      isAlwaysSelectable ? Future.value(true) : canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));
}

@immutable
class NoBibleApp extends BibleApp {
  @override
  bool get isAlwaysSelectable => true;
  @override
  String get name => 'None';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('');
}

class YouVersionBibleApp extends BibleApp {
  @override
  String get name => 'You Version';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('youversion://bible?reference=${f.book.osisParatextAbbrev}.${f.chapter}');
}

@immutable
class WeDevoteBibleApp extends BibleApp {
  @override
  String get name => 'We Devote';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('wdbible://bible/${f.book.osisParatextAbbrev}.${f.chapter}');
}
