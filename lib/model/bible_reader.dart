import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/book.dart';
import '/extension/log.dart';
import '/model/feed.dart';
import '/model/feeds.dart';

abstract class BibleReader {
  String get displayName => 'None';
  String get uriScheme => '';
  String getUriPath(Feed f) => '';

  Uri getDeeplinkUri(Feed f) => Uri.parse('$uriScheme${getUriPath(f)}');
  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));
  Future<bool> isSelectable() async => canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));
  Future<bool> launch(Feed f) async => await launchUrl(getDeeplinkUri(f).log());
}

//// working...

@immutable
class NoBibleReader extends BibleReader {
  @override
  Future<bool> isSelectable() async => Future.value(true);
}

class YouVersionBibleReader extends BibleReader {
  @override
  String get displayName => 'YouVersion app';
  @override
  String get uriScheme => 'youversion://';
  @override
  String getUriPath(f) => 'bible?reference=${f.book.osisParatextAbbrev}.${f.chapter}';
}

@immutable
class BlueLetterBibleReader extends BibleReader {
  @override
  String get displayName => 'Blue Letter Bible';
  @override
  String get uriScheme => 'http://';
  @override
  String getUriPath(f) {
    final bookRef = {
          'ezk': 'eze',
          'jol': 'joe',
          'nam': 'nah',
          'rut': 'rth',
        }[f.book.osisParatextAbbrev] ??
        f.book.osisParatextAbbrev;
    return 'blueletterbible.org/nkjv/$bookRef/${f.chapter}/1/p1/';
  }
}

//// the following readers have issues and are not working 100%...

// https://github.com/AndBible/and-bible/issues/3210
// class AndBibleReader extends BibleReader {
//   @override
//   String get displayName => 'AndBible app';
//   @override
//   Uri getDeeplinkUri(Feed f) => Uri.parse('https://read.andbible.org/1Sam.1.2');
// }
//
// @immutable
// class BibleHubBibleReader extends BibleReader {
//   @override
//   String get displayName => 'BibleHub web';
//   @override
//   Uri getDeeplinkUri(Feed f) => Uri.parse('https://biblehub.com/${f.book.osisParatextAbbrev}/${f.chapter}.htm');
// }
//
// @immutable
// class BlueLetterBibleReader extends BibleReader {
//   @override
//   String get displayName => 'Blue Letter Bible';
//   @override
//   Uri getDeeplinkUri(Feed f) =>
//       Uri.parse('https://www.blueletterbible.org/kjv/${f.book.osisParatextAbbrev}/${f.chapter}/1/');
// }
//
// class OliveTreeBibleReader extends BibleReader {
//   @override
//   String get displayName => 'Olive Tree app';
//   @override
//   Uri getDeeplinkUri(Feed f) => Uri.parse('olivetree://bible/${f.book.osisParatextAbbrev}.${f.chapter}');
// }
//
// @immutable
// class WeDevoteBibleReader extends BibleReader {
//   @override
//   String get displayName => 'WeDevote app';
//   @override
//   Uri getDeeplinkUri(Feed f) => Uri.parse('wdbible://bible/${f.book.osisParatextAbbrev}.${f.chapter}');
// }
