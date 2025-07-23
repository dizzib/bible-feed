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
  String get uri => '';
  Map<String, String> get bookAbbrevNonStandardTweaks => {}; // needed because some readers deviate from the standard
  List<TargetPlatform> get certifiedPlatforms => []; // platforms confirmed working with no issues
  Future<bool> isSelectable() async => canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));

  @nonVirtual
  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));

  @nonVirtual
  Uri getDeeplinkUri(Feed f) {
    final bookAbbrev = bookAbbrevNonStandardTweaks[f.book.osisParatextAbbrev] ?? f.book.osisParatextAbbrev;
    return Uri.parse(uri.replaceAll('BOOK', bookAbbrev).replaceAll('CHAPTER', f.chapter.toString())).log();
  }

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
  String get uri => 'https://read.andbible.org/BOOK.CHAPTER';
}

@immutable
// todo: allow select version
class BibleHubBibleReader extends BibleReader {
  @override
  String get displayName => 'BibleHub web';
  @override
  String get uri => 'https://biblehub.com/BOOK/CHAPTER.htm';
}

@immutable
// does not launch app, only web
class BlueLetterBibleReader extends BibleReader {
  @override
  String get displayName => 'Blue Letter Bible';
  @override
  Map<String, String> get bookAbbrevNonStandardTweaks => {
        'ezk': 'eze',
        'jol': 'joe',
        'nam': 'nah',
        'rut': 'rth',
      };
  @override
  String get uri => 'https://blueletterbible.org/nkjv/BOOK/CHAPTER/1/p1/';
}

@immutable
// unknown path does not work
class LifeBibleReader extends BibleReader {
  @override
  String get displayName => 'Life Bible app';
  @override
  String get uri => 'tecartabible://BOOK.CHAPTER';
}

@immutable
class NoBibleReader extends BibleReader {
  @override
  String get displayName => 'None';
  @override
  List<TargetPlatform> get certifiedPlatforms => [TargetPlatform.android, TargetPlatform.iOS];
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
  Map<String, String> get bookAbbrevNonStandardTweaks => {
        'jhn': 'jn',
        'rut': 'rth',
        'nam': 'nah',
        'oba': 'obd',
      };
  @override
  String get uri => 'olivetree://bible/BOOK.CHAPTER';
}

@immutable
// does not open ref
class WeDevoteBibleReader extends BibleReader {
  @override
  String get displayName => 'WeDevote app';
  @override
  String get uri => 'wdbible://bible/BOOK.CHAPTER';
}

@immutable
class YouVersionBibleReader extends BibleReader {
  @override
  String get displayName => 'YouVersion app';
  @override
  List<TargetPlatform> get certifiedPlatforms => [TargetPlatform.android, TargetPlatform.iOS];
  @override
  String get uri => 'youversion://bible?reference=BOOK.CHAPTER';
}
