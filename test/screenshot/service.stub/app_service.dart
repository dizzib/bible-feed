import 'dart:io';

import 'package:bible_feed/service/app_service.dart' as base;
import 'package:injectable/injectable.dart';
import 'package:yaml/yaml.dart';

@Environment('screenshot')
@LazySingleton(as: base.AppService)
class AppService extends base.AppService {
  AppService({required super.buildNumber, required super.version});

  @factoryMethod
  @preResolve
  static Future<AppService> create() async {
    final yaml = loadYaml(await File('pubspec.yaml').readAsString());
    final versionAndBuild = yaml['version'].split('+');
    return AppService(buildNumber: versionAndBuild[1].toString(), version: versionAndBuild[0].toString());
  }
}
