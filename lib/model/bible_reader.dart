import 'dart:io';
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
  String get uriScheme;
  String getUriPath(Feed f);
  List<TargetPlatform> get certifiedPlatforms => []; // platforms confirmed working with no issues
  Future<bool> isSelectable() async => canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));

  @nonVirtual
  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));

  @nonVirtual
  Uri getDeeplinkUri(Feed f) => Uri.parse('$uriScheme${getUriPath(f)}');

  @nonVirtual
  bool get isCertifiedForThisPlatform =>
      (Platform.isAndroid && certifiedPlatforms.contains(TargetPlatform.android)) ||
      (Platform.isIOS && certifiedPlatforms.contains(TargetPlatform.iOS));

  @nonVirtual
  Future<bool> launch(Feed f) async => await launchUrl(getDeeplinkUri(f).log());
}

//// implementations

@immutable
// https://github.com/AndBible/and-bible/issues/3210
class AndBibleReader extends BibleReader {
  @override
  String get displayName => 'AndBible app';
  @override
  String get uriScheme => 'https://';
  @override
  String getUriPath(f) => 'read.andbible.org/${f.book.osisParatextAbbrev}.${f.chapter}';
}

@immutable
// todo: allow select version
class BibleHubBibleReader extends BibleReader {
  @override
  String get displayName => 'BibleHub web';
  @override
  String get uriScheme => 'https://';
  @override
  String getUriPath(Feed f) => 'biblehub.com/${f.book.osisParatextAbbrev}/${f.chapter}.htm';
}

@immutable
// does not launch app, only web
class BlueLetterBibleReader extends BibleReader {
  @override
  String get displayName => 'Blue Letter Bible';
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
// unknown path does not work
class LifeBibleReader extends BibleReader {
  @override
  String get displayName => 'Life Bible app';
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
  List<TargetPlatform> get certifiedPlatforms => [TargetPlatform.android, TargetPlatform.iOS];
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
  List<TargetPlatform> get certifiedPlatforms => [TargetPlatform.iOS]; // android: back doesn't return to bible feed
  @override
  String get uriScheme => 'olivetree://';
  @override
  String getUriPath(f) {
    final bookRef = {
          'jhn': 'john',
        }[f.book.osisParatextAbbrev] ??
        f.book.osisParatextAbbrev;
    return 'bible/$bookRef.${f.chapter}';
  }
}

@immutable
// does not open ref
class WeDevoteBibleReader extends BibleReader {
  @override
  String get displayName => 'WeDevote app';
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
  List<TargetPlatform> get certifiedPlatforms => [TargetPlatform.android, TargetPlatform.iOS];
  @override
  String get uriScheme => 'youversion://';
  @override
  String getUriPath(f) => 'bible?reference=${f.book.osisParatextAbbrev}.${f.chapter}';
}
