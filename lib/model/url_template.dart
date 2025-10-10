import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class UrlTemplate extends DelegatingMap<TargetPlatform, String> {
  // ignore: avoid-missing-enum-constant-in-map, other platforms are not supported
  UrlTemplate(String urlTemplate) : super({TargetPlatform.android: urlTemplate, TargetPlatform.iOS: urlTemplate});

  UrlTemplate.byPlatform({required String android, required String iOS})
    // ignore: avoid-missing-enum-constant-in-map, other platforms are not supported
    : super({TargetPlatform.android: android, TargetPlatform.iOS: iOS});
}
