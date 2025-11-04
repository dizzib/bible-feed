import 'package:injectable/injectable.dart';

@lazySingleton
class JsonEncodingManager {
  String encode(String json) {
    return Uri.encodeComponent(json);
  }

  String decode(String encoded) {
    return Uri.decodeComponent(encoded);
  }
}
