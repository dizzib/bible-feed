import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@integrationTest
@midnightTest
@LazySingleton(as: StoreService)
class EmptyStoreService extends StoreService {
  // TODO replace with SharedPreferencesWithCache when it supports unit tests
  // https://github.com/flutter/flutter/issues/159597

  EmptyStoreService(super._sharedPreferences);

  @factoryMethod
  @preResolve
  static Future<StoreService> create() async {
    final sp = await SharedPreferences.getInstance();
    sp.clear();
    return EmptyStoreService(sp);
  }
}
