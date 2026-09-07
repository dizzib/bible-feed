import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import 'feed.dart';

part 'share_dto.mapper.dart';

@immutable
@MappableClass()
class ShareDto with ShareDtoMappable {
  ShareDto({required this.version, required this.feedList, required this.virtualAllDoneDate});

  final String version;
  final List<Feed> feedList;
  final DateTime virtualAllDoneDate;
}
