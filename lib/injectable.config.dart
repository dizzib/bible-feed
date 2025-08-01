// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bible_feed/injectable.dart' as _i537;
import 'package:bible_feed/model/bible_readers.dart' as _i1070;
import 'package:bible_feed/model/feeds.dart' as _i759;
import 'package:bible_feed/model/list_wheel_state.dart' as _i1033;
import 'package:bible_feed/model/reading_lists.dart' as _i823;
import 'package:bible_feed/service/all_done_dialog_service.dart' as _i136;
import 'package:bible_feed/service/auto_advance_service.dart' as _i148;
import 'package:bible_feed/service/bible_reader_app_install_service.dart'
    as _i229;
import 'package:bible_feed/service/bible_reader_service.dart' as _i283;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i1033.BookListWheelState>(
        () => _i1033.BookListWheelState());
    gh.lazySingleton<_i1033.ChapterListWheelState>(
        () => _i1033.ChapterListWheelState());
    gh.lazySingleton<_i1070.BibleReaders>(() => _i1070.BibleReaders());
    gh.lazySingleton<_i229.BibleReaderAppInstallService>(
        () => _i229.BibleReaderAppInstallService());
    gh.lazySingleton<_i823.ReadingLists>(
      () => _i823.PghReadingLists(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i283.BibleReaderService>(() => _i283.BibleReaderService(
          gh<_i229.BibleReaderAppInstallService>(),
          gh<_i1070.BibleReaders>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i759.Feeds>(() => _i759.Feeds(
          gh<_i823.ReadingLists>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i136.AllDoneDialogService>(
        () => _i136.AllDoneDialogService(gh<_i759.Feeds>()));
    gh.singleton<_i148.AutoAdvanceService>(
        () => _i148.AutoAdvanceService(gh<_i759.Feeds>()));
    return this;
  }
}

class _$RegisterModule extends _i537.RegisterModule {}
