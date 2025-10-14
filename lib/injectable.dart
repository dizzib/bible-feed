import 'package:injectable/injectable.dart';
import 'package:watch_it/watch_it.dart';

import 'injectable.config.dart'; // AUTO-GENERATED

@InjectableInit(generateForDir: ['lib'])
// ignore: prefer-static-class, allow global
Future configureDependencies() async {
  await di.init(environment: 'prod');
}
