import 'package:flutter/foundation.dart';

import 'bible_reader_key.dart';
import 'bible_reader_type.dart';
import 'book_key_externaliser.dart';
import 'url_template.dart';

@immutable
class BibleReader {
  const BibleReader({
    required BibleReaderKey key,
    required BibleReaderType type,
    required String name,
    required UrlTemplate urlTemplate,
    List<TargetPlatform> certifiedPlatforms = const [],
    BookKeyExternaliser bookKeyExternaliser = BookKeyExternaliser.identity,
    String? urlVersePath,
  }) : _key = key,
       _type = type,
       _name = name,
       _urlTemplate = urlTemplate,
       _certifiedPlatforms = certifiedPlatforms,
       _bookKeyExternaliser = bookKeyExternaliser,
       _urlVersePath = urlVersePath;

  final BibleReaderKey _key;
  final BibleReaderType _type;
  final BookKeyExternaliser _bookKeyExternaliser;
  final List<TargetPlatform> _certifiedPlatforms; // platforms confirmed working with no issues
  final String _name;
  final UrlTemplate _urlTemplate;
  final String? _urlVersePath;

  // field getters
  BookKeyExternaliser get bookKeyExternaliser => _bookKeyExternaliser;
  List<TargetPlatform> get certifiedPlatforms => _certifiedPlatforms;
  BibleReaderKey get key => _key;
  String get name => _name;
  UrlTemplate get urlTemplate => _urlTemplate;
  String? get urlVersePath => _urlVersePath;

  // calculated getters
  String get displayName => '$_name ${isNone ? '' : _type.name}'.trim();
  bool get isApp => _type == BibleReaderType.app;
  bool get isNone => _type == BibleReaderType.none;
}
