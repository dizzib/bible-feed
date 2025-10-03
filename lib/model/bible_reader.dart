import 'package:flutter/foundation.dart';

import 'bible_reader_key.dart';
import 'bible_reader_type.dart';
import 'book_key_externaliser.dart';

// for ios, scheme must be added to info.plist!!!
@immutable
class BibleReader {
  const BibleReader({
    required BibleReaderKey key,
    required BibleReaderType type,
    required String name,
    required String uriTemplate,
    required List<TargetPlatform> certifiedPlatforms,
    BookKeyExternaliser bookKeyExternaliser = BookKeyExternaliser.identity,
    String? uriVersePath,
  }) : _key = key,
       _type = type,
       _name = name,
       _uriTemplate = uriTemplate,
       _certifiedPlatforms = certifiedPlatforms,
       _bookKeyExternaliser = bookKeyExternaliser,
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
  List<TargetPlatform> get certifiedPlatforms => _certifiedPlatforms;
  BibleReaderKey get key => _key;
  String get name => _name;
  String get uriTemplate => _uriTemplate;
  String? get uriVersePath => _uriVersePath;

  // calculated getters
  String get displayName => '$_name ${isNone ? '' : _type.name}'.trim();
  bool get isApp => _type == BibleReaderType.app;
  bool get isNone => _type == BibleReaderType.none;
}
