import 'dart:io';

import 'package:bible_feed/service/app_service.dart';
import 'package:injectable/injectable.dart';
import 'package:yaml/yaml.dart';

import '../injectable.dart';

@screenshot
@LazySingleton(as: AppService)
class TestAppService extends AppService {
  TestAppService({required super.buildNumber, required super.version});

  @factoryMethod
  @preResolve
  static Future<TestAppService> create() async {
    final yaml = loadYaml(await File('pubspec.yaml').readAsString());
    final versionAndBuild = yaml['version'].split('+');
    return TestAppService(buildNumber: versionAndBuild[1].toString(), version: versionAndBuild[0].toString());
  }
}
