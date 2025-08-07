import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';

import '/extension/object.dart';
import 'bible_reader_book_keymap.dart';
import 'feed.dart';
import 'feeds.dart';

@immutable
// for ios, scheme must be added to info.plist!!!
class BibleReader {
  const BibleReader(this.displayName, this.uri, this.certifiedPlatforms,
      [this.bookKeyMap = const IdentityBookKeyMap()]);

  final BibleReaderBookKeyMap bookKeyMap;
  final List<TargetPlatform> certifiedPlatforms; // platforms confirmed working with no issues
  final String displayName;
  final String uri;

  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(getDeeplinkUri(f));

  Uri getDeeplinkUri(Feed f) {
    final bookId = bookKeyMap.apply(f.book);
    return Uri.parse(uri.replaceAll('BOOK', bookId).replaceAll('CHAPTER', f.chapter.toString())).log();
  }

  Future<bool> isAvailable() async {
    if (uri.isEmpty) return Future.value(true);
    return canLaunchUrl(getDeeplinkUri(sl<Feeds>()[0]));
  }

  bool get isCertifiedForThisPlatform =>
      (Platform.isAndroid && certifiedPlatforms.contains(TargetPlatform.android)) ||
      (Platform.isIOS && certifiedPlatforms.contains(TargetPlatform.iOS));

  Future<bool> launch(Feed f) async => await launchUrl(getDeeplinkUri(f).log());
}
