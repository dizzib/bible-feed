import 'package:bible_feed/model/book.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:bible_feed/model/reading_list.dart';
import 'package:bible_feed/service/app_service.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:injectable/injectable.dart';

const b0 = Book('b0', 'Book 0', 1);
const b1 = Book('b1', 'Book 1', 3);
var rl0 = ReadingList('rl0', 'Reading List 0', const [b0]);
var rl1 = ReadingList('rl1', 'Reading List 1', const [b0, b1]);

@test
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

@test
@LazySingleton(as: PlatformService)
class TestPlatformService extends PlatformService {
  TestPlatformService() : super(isAndroid: true, isIOS: false, isHapticAvailable: true);
}
