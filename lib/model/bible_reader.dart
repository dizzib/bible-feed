import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/log.dart';
import '/model/book.dart';
import '/model/feed.dart';
import '/model/feeds.dart';

@immutable
abstract class BibleReader {
  String get displayName => 'None';
  String get uriScheme => '';
  String getUriPath(Feed f) => '';
  Future<bool> isSelectable() async => canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));

  @nonVirtual
  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));
  @nonVirtual
  Uri getDeeplinkUri(Feed f) => Uri.parse('$uriScheme${getUriPath(f)}');
  @nonVirtual
  Future<bool> launch(Feed f) async => await launchUrl(getDeeplinkUri(f).log());
}

//// working...

@immutable
class NoBibleReader extends BibleReader {
  @override
  Future<bool> isSelectable() async => Future.value(true);
}

@immutable
class YouVersionBibleReader extends BibleReader {
  @override
  String get displayName => 'YouVersion app';
  @override
  String get uriScheme => 'youversion://';
  @override
  String getUriPath(f) => 'bible?reference=${f.book.osisParatextAbbrev}.${f.chapter}';
}

//// the following readers have issues and are not working 100%...

// https://github.com/AndBible/and-bible/issues/3210
// @immutable
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
//   String get uriScheme => 'https://';
//   @override
//   String getUriPath(f) {
//     final bookRef = {
//           'ezk': 'eze',
//           'jol': 'joe',
//           'nam': 'nah',
//           'rut': 'rth',
//         }[f.book.osisParatextAbbrev] ??
//         f.book.osisParatextAbbrev;
//     return 'blueletterbible.org/nkjv/$bookRef/${f.chapter}/1/p1/';
//   }
// }
//
// @immutable
// class LifeBibleReader extends BibleReader {
//   @override
//   String get displayName => 'Life Bible app';
//   @override
//   String get uriScheme => 'tecartabible://';
//   @override
//   String getUriPath(f) => '${f.book.osisParatextAbbrev}.${f.chapter}';
// }
//
// @immutable
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
