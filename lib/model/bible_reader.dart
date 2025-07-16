import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/book.dart';
import '/extension/log.dart';
import '/model/feed.dart';
import '/model/feeds.dart';

abstract class BibleReader {
  String get name;
  Uri getDeeplinkUri(Feed f);

  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));
  Future<bool> isSelectable() async => canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));
  Future<bool> launch(Feed f) async => await launchUrl(getDeeplinkUri(f).log());
}

//// working...

@immutable
class NoBibleReader extends BibleReader {
  @override
  Future<bool> isSelectable() async => Future.value(true);
  @override
  String get name => 'None';
  @override
  Uri getDeeplinkUri(Feed f) => Uri();
}

class YouVersionBibleReader extends BibleReader {
  @override
  String get name => 'YouVersion app';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('youversion://bible?reference=${f.book.osisParatextAbbrev}.${f.chapter}');
}

//// the following readers have issues and are not working 100%...

// https://github.com/AndBible/and-bible/issues/3210
class AndBibleReader extends BibleReader {
  @override
  String get name => 'AndBible app';
  @override
  // Uri getDeeplinkUri(Feed f) => Uri.parse('https://read.andbible.org/${f.book.osisParatextAbbrev}.${f.chapter}.1');
  Uri getDeeplinkUri(Feed f) => Uri.parse('https://read.andbible.org/1Sam.1.2');
}

@immutable
class BibleHubBibleReader extends BibleReader {
  @override
  String get name => 'BibleHub web';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('https://biblehub.com/${f.book.osisParatextAbbrev}/${f.chapter}.htm');
}

@immutable
class BlueLetterBibleReader extends BibleReader {
  @override
  String get name => 'Blue Letter Bible';
  @override
  Uri getDeeplinkUri(Feed f) =>
      Uri.parse('https://www.blueletterbible.org/kjv/${f.book.osisParatextAbbrev}/${f.chapter}/1/');
}

class OliveTreeBibleReader extends BibleReader {
  @override
  String get name => 'Olive Tree app';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('olivetree://bible/${f.book.osisParatextAbbrev}.${f.chapter}');
}

@immutable
class WeDevoteBibleReader extends BibleReader {
  @override
  String get name => 'WeDevote app';
  @override
  Uri getDeeplinkUri(Feed f) => Uri.parse('wdbible://bible/${f.book.osisParatextAbbrev}.${f.chapter}');
}
