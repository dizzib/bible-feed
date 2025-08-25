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
  const BibleReader(
    this.displayName,
    this.uriTemplate,
    this.certifiedPlatforms, {
    this.bookKeyMap = const IdentityBookKeyMap(),
    this.uriVersePath,
  });

  final BibleReaderBookKeyMap bookKeyMap;
  final List<TargetPlatform> certifiedPlatforms; // platforms confirmed working with no issues
  final String displayName;
  final String uriTemplate;
  final String? uriVersePath;

  Uri _getDeeplinkUri(FeedState state) {
    final bookId = bookKeyMap.apply(state.book);
    var uri = uriTemplate.replaceAll('BOOK', bookId).replaceAll('CHAPTER', state.chapter.toString());
    if (uriVersePath != null && state.verse > 1) {
      uri += uriVersePath!.replaceAll('VERSE', state.verse.toString());
    }
    return Uri.parse(uri).log();
  }

  bool get isCertifiedForThisPlatform =>
      (Platform.isAndroid && certifiedPlatforms.contains(TargetPlatform.android)) ||
      (Platform.isIOS && certifiedPlatforms.contains(TargetPlatform.iOS));

  Future<bool> canLaunch(Feed f) async => await canLaunchUrl(_getDeeplinkUri(f.state));

  Future<bool> isAvailable() async {
    if (uriTemplate.isEmpty) return Future.value(true);
    return canLaunchUrl(_getDeeplinkUri(sl<Feeds>()[0].state));
  }

  Future<bool> launch(Feed f) async => await launchUrl(_getDeeplinkUri(f.state).log());
}
