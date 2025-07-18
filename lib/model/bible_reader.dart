import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/object.dart';
import '/model/book.dart';
import '/model/feed.dart';
import '/model/feeds.dart';

@immutable
abstract class BibleReader {
  String get displayName;
  bool get isCertified; // true if confirmed working with no issues
  String get uriScheme;
  String getUriPath(Feed f);
  Future<bool> isSelectable() async => canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));

  @nonVirtual
  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));
  @nonVirtual
  Uri getDeeplinkUri(Feed f) => Uri.parse('$uriScheme${getUriPath(f)}');
  @nonVirtual
  Future<bool> launch(Feed f) async => await launchUrl(getDeeplinkUri(f).log());
}

//// implementations

@immutable
class AndBibleReader extends BibleReader {
  @override
  String get displayName => 'AndBible app';
  @override
  bool get isCertified => false; // https://github.com/AndBible/and-bible/issues/3210
  @override
  String get uriScheme => 'https://';
  @override
  String getUriPath(f) => 'read.andbible.org/${f.book.osisParatextAbbrev}.${f.chapter}';
}

@immutable
class BibleHubBibleReader extends BibleReader {
  @override
  String get displayName => 'BibleHub web';
  @override
  bool get isCertified => false; // todo: allow select version
  @override
  String get uriScheme => 'https://';
  @override
  String getUriPath(Feed f) => 'biblehub.com/${f.book.osisParatextAbbrev}/${f.chapter}.htm';
}

@immutable
class BlueLetterBibleReader extends BibleReader {
  @override
  String get displayName => 'Blue Letter Bible';
  @override
  bool get isCertified => false; // does not launch app, only web
  @override
  String get uriScheme => 'https://';
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

@immutable
class LifeBibleReader extends BibleReader {
  @override
  String get displayName => 'Life Bible app';
  @override
  bool get isCertified => false; // unknown path does not work
  @override
  String get uriScheme => 'tecartabible://';
  @override
  String getUriPath(f) => '${f.book.osisParatextAbbrev}.${f.chapter}';
}

@immutable
class NoBibleReader extends BibleReader {
  @override
  String get displayName => 'None';
  @override
  bool get isCertified => true;
  @override
  String get uriScheme => '';
  @override
  String getUriPath(f) => '';
  @override
  Future<bool> isSelectable() async => Future.value(true);
}

@immutable
class OliveTreeBibleReader extends BibleReader {
  @override
  String get displayName => 'Olive Tree app';
  @override
  bool get isCertified => false; // back button does not return to bible feed
  @override
  String get uriScheme => 'olivetree://';
  @override
  String getUriPath(f) => 'bible/${f.book.osisParatextAbbrev}.${f.chapter}';
}

@immutable
class WeDevoteBibleReader extends BibleReader {
  @override
  String get displayName => 'WeDevote app';
  @override
  bool get isCertified => false; // does not open ref
  @override
  String get uriScheme => 'wdbible://';
  @override
  String getUriPath(f) => 'bible/${f.book.osisParatextAbbrev}.${f.chapter}';
}

@immutable
class YouVersionBibleReader extends BibleReader {
  @override
  String get displayName => 'YouVersion app';
  @override
  bool get isCertified => true;
  @override
  String get uriScheme => 'youversion://';
  @override
  String getUriPath(f) => 'bible?reference=${f.book.osisParatextAbbrev}.${f.chapter}';
}
