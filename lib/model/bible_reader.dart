import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/object.dart';
import '/model/feed.dart';
import '/model/feeds.dart';
import 'bible_reader_keymap.dart';

@immutable
// for ios, scheme must be added to info.plist!!!
abstract class BibleReader {
  String get displayName;
  String get uri => '';
  BibleReaderKeyMap get bibleReaderKeyMap => IdentityBibleReaderKeyMap();
  List<TargetPlatform> get certifiedPlatforms => []; // platforms confirmed working with no issues
  Future<bool> isSelectable() async => canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));

  @nonVirtual
  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));

  @nonVirtual
  Uri getDeeplinkUri(Feed f) {
    final bookId = bibleReaderKeyMap.apply(f.book);
    return Uri.parse(uri.replaceAll('BOOK', bookId).replaceAll('CHAPTER', f.chapter.toString())).log();
  }

  @nonVirtual
  bool get isCertifiedForThisPlatform =>
      (Platform.isAndroid && certifiedPlatforms.contains(TargetPlatform.android)) ||
      (Platform.isIOS && certifiedPlatforms.contains(TargetPlatform.iOS));

  @nonVirtual
  Future<bool> launch(Feed f) async => await launchUrl(getDeeplinkUri(f).log());
}

//// implementations

@immutable // https://github.com/AndBible/and-bible/issues/3210
class AndBibleReader extends BibleReader {
  @override
  String get displayName => 'AndBible app';
  @override
  String get uri => 'https://read.andbible.org/BOOK.CHAPTER';
}

@immutable // biblehub app not detected on android or ios
class BibleHubBibleReader extends BibleReader {
  @override
  String get displayName => 'BibleHub';
  @override
  String get uri => 'biblehub://BOOK/CHAPTER';
}

@immutable
class BlueLetterBibleReader extends BibleReader {
  @override
  String get displayName => 'Blue Letter Bible';
  @override // android: does not launch app because App info -> 'Open by default' shows '0 verified links'.
  List<TargetPlatform> get certifiedPlatforms => [TargetPlatform.iOS];
  @override
  BibleReaderKeyMap get bibleReaderKeyMap => BlueLetterBibleReaderKeyMap();
  @override
  String get uri => 'blb://BOOK/CHAPTER';
}

@immutable // unknown path does not work
class LifeBibleReader extends BibleReader {
  @override
  String get displayName => 'Life Bible app';
  @override
  String get uri => 'tecartabible://BOOK.CHAPTER';
}

@immutable
class LogosBibleReader extends BibleReader {
  @override
  String get displayName => 'Logos Bible app';
  @override
  List<TargetPlatform> get certifiedPlatforms => [TargetPlatform.iOS]; // android: back doesn't return to bible feed
  @override
  BibleReaderKeyMap get bibleReaderKeyMap => LogosBibleReaderKeyMap();
  @override
  String get uri => 'logosref:Bible.BOOK.CHAPTER';
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
  BibleReaderKeyMap get bibleReaderKeyMap => OliveTreeBibleReaderKeyMap();
  @override
  String get uri => 'olivetree://bible/BOOK.CHAPTER';
}

@immutable // see https://nickperkins.dev/2022/08/02/find-every-ios-bible-app-deeplink-url-scheme/
class WeDevoteBibleReader extends BibleReader {
  @override
  String get displayName => 'WeDevote app';
  @override
  List<TargetPlatform> get certifiedPlatforms => [TargetPlatform.iOS]; // android: does not open ref
  @override
  BibleReaderKeyMap get bibleReaderKeyMap => OsisParatextBibleReaderKeyMap();
  @override
  String get uri => 'wdbible://bible/BOOK.CHAPTER';
}

@immutable // see https://nickperkins.dev/2022/08/02/find-every-ios-bible-app-deeplink-url-scheme/
class YouVersionBibleReader extends BibleReader {
  @override
  String get displayName => 'YouVersion app';
  @override
  List<TargetPlatform> get certifiedPlatforms => [TargetPlatform.android, TargetPlatform.iOS];
  @override
  BibleReaderKeyMap get bibleReaderKeyMap => OsisParatextBibleReaderKeyMap();
  @override
  String get uri => 'youversion://bible?reference=BOOK.CHAPTER';
}
