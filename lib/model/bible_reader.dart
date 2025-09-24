import 'package:flutter/foundation.dart';

import '/model.production/bible_reader_key.dart';
import '/model.production/book_key_externaliser.dart';
import '/service/platform_service.dart';
import 'bible_reader_type.dart';

// for ios, scheme must be added to info.plist!!!
@immutable
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

  // field getters
  BookKeyExternaliser get bookKeyExternaliser => _bookKeyExternaliser;
  BibleReaderKey get key => _key;
  String get name => _name;
  String get uriTemplate => _uriTemplate;
  String? get uriVersePath => _uriVersePath;

  // calculated getters
  String get displayName => '$_name ${isNone ? '' : _type.name}'.trim();
  bool get isApp => _type == BibleReaderType.app;
  bool get isNone => _type == BibleReaderType.none;

  bool isCertified(PlatformService platformService) =>
      (platformService.isAndroid && _certifiedPlatforms.contains(TargetPlatform.android)) ||
      (platformService.isIOS && _certifiedPlatforms.contains(TargetPlatform.iOS));
}
