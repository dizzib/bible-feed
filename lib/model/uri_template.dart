import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class UriTemplate extends DelegatingMap<TargetPlatform, String> {
  // ignore: avoid-missing-enum-constant-in-map, other platforms are not supported
  UriTemplate(String uriTemplate) : super({TargetPlatform.android: uriTemplate, TargetPlatform.iOS: uriTemplate});

  UriTemplate.byPlatform({required String android, required String iOS})
    // ignore: avoid-missing-enum-constant-in-map, other platforms are not supported
    : super({TargetPlatform.android: android, TargetPlatform.iOS: iOS});
}
