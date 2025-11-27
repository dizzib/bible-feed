import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import 'feed.dart';

part 'share_dto.mapper.dart';

@immutable
@MappableClass()
class ShareDto with ShareDtoMappable {
  ShareDto({required this.buildNumber, required this.feedStateList, required this.virtualAllDoneDate});

  final String buildNumber;
  final List<FeedState> feedStateList;
  final DateTime virtualAllDoneDate;
}
