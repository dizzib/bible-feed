import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';

import '/model.production/bible_reader_key.dart';
import '/model.production/book_key_externaliser.dart';
import '/service/platform_service.dart';
import 'bible_reader_type.dart';
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

  final BibleReaderKey _key;
  final BibleReaderType _type;
  final BookKeyExternaliser _bookKeyExternaliser;
  final List<TargetPlatform> _certifiedPlatforms; // platforms confirmed working with no issues
  final String _name;
  final String _uriTemplate;
  final String? _uriVersePath;

  Uri _getDeeplinkUri(FeedState state) {
    final externalBookKey = _bookKeyExternaliser.getExternalBookKey(state.book.key);
    var uri = uriTemplate.replaceAll('BOOK', externalBookKey).replaceAll('CHAPTER', state.chapter.toString());
    if (uriVersePath != null && state.verse > 1) {
      uri += uriVersePath!.replaceAll('VERSE', state.verse.toString());
    }
    return Uri.parse(uri);
  }

  List<TargetPlatform> get certifiedPlatforms => _certifiedPlatforms;
  String get displayName => '$_name ${_key == BibleReaderKey.none ? '' : _type.name}'.trim();
  bool get isApp => _type == BibleReaderType.app;
  BibleReaderKey get key => _key;
  String get name => _name;
  String get uriTemplate => _uriTemplate;
  String? get uriVersePath => _uriVersePath;

  Future<bool> isAvailable() async {
    if (_type == BibleReaderType.none) return Future.value(true);
    return canLaunchUrl(_getDeeplinkUri(sl<Feeds>()[0].state)); // attempt to launch first feed uri
  }

  bool isCertified(PlatformService platformService) =>
      (platformService.isAndroid && certifiedPlatforms.contains(TargetPlatform.android)) ||
      (platformService.isIOS && certifiedPlatforms.contains(TargetPlatform.iOS));

  Future<bool> launch(FeedState state) async => launchUrl(_getDeeplinkUri(state));
}
