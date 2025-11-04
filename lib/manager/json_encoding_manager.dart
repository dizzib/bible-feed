import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';

@lazySingleton
class JsonEncodingManager {
  String encode(String json) {
    final compressed = GZipCodec().encode(utf8.encode(json));
    return base64UrlEncode(compressed);
  }

  String decode(String base64Encoded) {
    final compressed = base64Url.decode(base64Encoded);
    return utf8.decode(GZipCodec().decode(compressed));
  }
}
