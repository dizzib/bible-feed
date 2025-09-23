import 'package:flutter/foundation.dart';

import '../service/url_launch_service.dart';
import '/model.production/bible_reader_key.dart';
import '/model.production/book_key_externaliser.dart';
import '/service/platform_service.dart';
import 'bible_reader_type.dart';
import 'feed.dart';

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

  Uri _getDeeplinkUri(String internalBookKey, [int chapter = 1, int verse = 1]) {
    final externalBookKey = _bookKeyExternaliser.getExternalBookKey(internalBookKey);
    var uri = uriTemplate.replaceAll('BOOK', externalBookKey).replaceAll('CHAPTER', chapter.toString());
    if (uriVersePath != null && verse > 1) {
      uri += uriVersePath!.replaceAll('VERSE', verse.toString());
    }
    return Uri.parse(uri);
  }

  BookKeyExternaliser get bookKeyExternaliser => _bookKeyExternaliser;
  List<TargetPlatform> get certifiedPlatforms => _certifiedPlatforms;
  String get displayName => '$_name ${_key == BibleReaderKey.none ? '' : _type.name}'.trim();
  bool get isApp => _type == BibleReaderType.app;
  bool get isNone => _key == BibleReaderKey.none;
  BibleReaderKey get key => _key;
  String get name => _name;
  String get uriTemplate => _uriTemplate;
  String? get uriVersePath => _uriVersePath;

  Future<bool> isAvailable(UrlLaunchService urlLaunchService) async {
    if (_type == BibleReaderType.none) return Future.value(true);
    return urlLaunchService.canLaunchUrl(_getDeeplinkUri('mat').toString());
  }

  bool isCertified(PlatformService platformService) =>
      (platformService.isAndroid && certifiedPlatforms.contains(TargetPlatform.android)) ||
      (platformService.isIOS && certifiedPlatforms.contains(TargetPlatform.iOS));

  Future<bool> launch(UrlLaunchService urlLaunchService, FeedState state) async =>
      urlLaunchService.launchUrl(_getDeeplinkUri(state.book.key, state.chapter, state.verse).toString());
}
