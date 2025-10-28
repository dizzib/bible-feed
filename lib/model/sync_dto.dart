import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'sync_dto.mapper.dart';

@immutable
@MappableClass()
class SyncDto with SyncDtoMappable {
  SyncDto({required this.version});

  final String version;
}
