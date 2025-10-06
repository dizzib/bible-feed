import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class UriTemplate extends DelegatingMap<TargetPlatform, String> {
  UriTemplate(String uriTemplate) : super({TargetPlatform.android: uriTemplate, TargetPlatform.iOS: uriTemplate});

  UriTemplate.byPlatform({required String android, required String iOS})
    : super({TargetPlatform.android: android, TargetPlatform.iOS: iOS});
}
