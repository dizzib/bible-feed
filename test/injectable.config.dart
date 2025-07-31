// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bible_feed/model/bible_readers.dart' as _i1070;
import 'package:bible_feed/model/feeds.dart' as _i759;
import 'package:bible_feed/model/list_wheel_state.dart' as _i1033;
import 'package:bible_feed/model/reading_lists.dart' as _i823;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'injectable.dart' as _i1027;
import 'mock/reading_lists_mock.dart' as _i490;

const String _test = 'test';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initTest({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModuleTest = _$RegisterModuleTest();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModuleTest.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i1033.BookListWheelState>(
        () => _i1033.BookListWheelState());
    gh.lazySingleton<_i1033.ChapterListWheelState>(
        () => _i1033.ChapterListWheelState());
    gh.lazySingleton<_i1070.BibleReaders>(() => _i1070.BibleReaders());
    gh.lazySingleton<_i823.ReadingLists>(
      () => _i490.ReadingListsMock(),
      registerFor: {_test},
    );
    gh.lazySingleton<_i759.Feeds>(() => _i759.Feeds(
          gh<_i823.ReadingLists>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i823.ReadingLists>(
      () => _i823.PghReadingLists(),
      registerFor: {_prod},
    );
    return this;
  }
}

class _$RegisterModuleTest extends _i1027.RegisterModuleTest {}
