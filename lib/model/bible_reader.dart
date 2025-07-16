import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';
import '/model/feed.dart';
import '/model/feeds.dart';

abstract class BibleReader {
  String get name;
  bool get isAlwaysSelectable => false;
  Uri getDeeplinkUri(Feed f);

  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));
  Future<bool> isSelectable() async =>
      isAlwaysSelectable ? Future.value(true) : canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));
  Future<bool> launch(Feed f) async => await launchUrl(getDeeplinkUri(f));
}

@immutable
class NoBibleReader extends BibleReader {
  @override
  bool get isAlwaysSelectable => true;
  @override
  String get name => 'None';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('');
}

class YouVersionBibleReader extends BibleReader {
  @override
  String get name => 'YouVersion app';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('youversion://bible?reference=${f.book.osisParatextAbbrev}.${f.chapter}');
}

@immutable
class WeDevoteBibleReader extends BibleReader {
  @override
  String get name => 'We Devote app';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('wdbible://bible/${f.book.osisParatextAbbrev}.${f.chapter}');
}
