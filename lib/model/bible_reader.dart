import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';

import '/service/platform_service.dart';
import 'bible_reader_book_keymap.dart';
import 'bible_reader_keys.dart';
import 'feed.dart';
import 'feeds.dart';

@immutable
// for ios, scheme must be added to info.plist!!!
class BibleReader {
  const BibleReader(
    this._key,
    this._displayName,
    this._uriTemplate,
    this._certifiedPlatforms, {
    bookKeyMap = const IdentityBookKeyMap(),
    uriVersePath,
  }) : _bookKeyMap = bookKeyMap,
       _uriVersePath = uriVersePath;

  final BibleReaderKeys _key;
  final BibleReaderBookKeyMap _bookKeyMap;
  final List<TargetPlatform> _certifiedPlatforms; // platforms confirmed working with no issues
  final String _displayName;
  final String _uriTemplate;
  final String? _uriVersePath;

  Uri _getDeeplinkUri(FeedState state) {
    final bookId = bookKeyMap.apply(state.book);
    var uri = uriTemplate.replaceAll('BOOK', bookId).replaceAll('CHAPTER', state.chapter.toString());
    if (uriVersePath != null && state.verse > 1) {
      uri += uriVersePath!.replaceAll('VERSE', state.verse.toString());
    }
    return Uri.parse(uri); //.log();
  }

  BibleReaderBookKeyMap get bookKeyMap => _bookKeyMap;
  List<TargetPlatform> get certifiedPlatforms => _certifiedPlatforms;
  String get displayName => _displayName;
  BibleReaderKeys get key => _key;
  String get uriTemplate => _uriTemplate;
  String? get uriVersePath => _uriVersePath;

  bool get isCertifiedForThisPlatform =>
      (sl<PlatformService>().isAndroid && certifiedPlatforms.contains(TargetPlatform.android)) ||
      (sl<PlatformService>().isIOS && certifiedPlatforms.contains(TargetPlatform.iOS));

  Future<bool> isAvailable() async {
    if (uriTemplate.isEmpty) return Future.value(true); // 'None' is always available
    return canLaunchUrl(_getDeeplinkUri(sl<Feeds>()[0].state)); // attempt to launch first feed uri
  }

  Future<bool> launch(FeedState state) async => launchUrl(_getDeeplinkUri(state));
}
