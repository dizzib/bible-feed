import 'dart:io';

import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/service/app_service.dart' as base;
import 'package:injectable/injectable.dart';
import 'package:yaml/yaml.dart';

@golden
@LazySingleton(as: base.AppService)
class ScreenshotAppService extends base.AppService {
  ScreenshotAppService({required super.buildNumber, required super.version});

  @factoryMethod
  @preResolve
  static Future<ScreenshotAppService> create() async {
    final yaml = loadYaml(await File('pubspec.yaml').readAsString());
    final versionAndBuild = yaml['version'].split('+');
    return ScreenshotAppService(buildNumber: versionAndBuild[1].toString(), version: versionAndBuild[0].toString());
  }
}
