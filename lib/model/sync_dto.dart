import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import 'feed.dart';

part 'sync_dto.mapper.dart';

@immutable
@MappableClass()
class SyncDto with SyncDtoMappable {
  SyncDto({required this.buildNumber, required this.feedStateList});

  final String buildNumber;
  final List<FeedState> feedStateList;
}
