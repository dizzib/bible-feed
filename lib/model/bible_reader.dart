import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';

import '/service/platform_service.dart';
import 'bible_reader_keys.dart';
import 'bible_reader_types.dart';
import 'book_key_externaliser.dart';
import 'feed.dart';
import 'feeds.dart';

@immutable
// for ios, scheme must be added to info.plist!!!
class BibleReader {
  const BibleReader(
    this._key,
    this._type,
    this._name,
    this._uriTemplate,
    this._certifiedPlatforms, {
    bookKeyExternaliser = BookKeyExternaliser.identity,
    uriVersePath,
  }) : _bookKeyExternaliser = bookKeyExternaliser,
       _uriVersePath = uriVersePath;

  final BibleReaderKeys _key;
  final BibleReaderTypes _type;
  final BookKeyExternaliser _bookKeyExternaliser;
  final List<TargetPlatform> _certifiedPlatforms; // platforms confirmed working with no issues
  final String _name;
  final String _uriTemplate;
  final String? _uriVersePath;

  Uri _getDeeplinkUri(FeedState state) {
    final externalBookKey = _bookKeyExternaliser.apply(state.book.key);
    var uri = uriTemplate.replaceAll('BOOK', externalBookKey).replaceAll('CHAPTER', state.chapter.toString());
    if (uriVersePath != null && state.verse > 1) {
      uri += uriVersePath!.replaceAll('VERSE', state.verse.toString());
    }
    return Uri.parse(uri);
  }

  List<TargetPlatform> get certifiedPlatforms => _certifiedPlatforms;
  String get displayName => '$_name ${_key == BibleReaderKeys.none ? '' : _type.name}'.trim();
  bool get isApp => _type == BibleReaderTypes.app;
  BibleReaderKeys get key => _key;
  String get name => _name;
  String get uriTemplate => _uriTemplate;
  String? get uriVersePath => _uriVersePath;

  Future<bool> isAvailable() async {
    if (_type == BibleReaderTypes.none) return Future.value(true);
    return canLaunchUrl(_getDeeplinkUri(sl<Feeds>()[0].state)); // attempt to launch first feed uri
  }

  bool isCertified(PlatformService platformService) =>
      (platformService.isAndroid && certifiedPlatforms.contains(TargetPlatform.android)) ||
      (platformService.isIOS && certifiedPlatforms.contains(TargetPlatform.iOS));

  Future<bool> launch(FeedState state) async => launchUrl(_getDeeplinkUri(state));
}
