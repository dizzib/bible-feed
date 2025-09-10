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
import 'package:bible_feed/model/production_bible_readers.dart' as _i545;
import 'package:bible_feed/model/production_reading_lists.dart' as _i438;
import 'package:bible_feed/model/verse_scopes.dart' as _i967;
import 'package:bible_feed/service/all_done_dialog_service.dart' as _i136;
import 'package:bible_feed/service/auto_advance_service.dart' as _i148;
import 'package:bible_feed/service/bible_reader_app_install_service.dart'
    as _i229;
import 'package:bible_feed/service/bible_reader_service.dart' as _i283;
import 'package:bible_feed/service/feed_store_service.dart' as _i119;
import 'package:bible_feed/service/feeds_advance_service.dart' as _i307;
import 'package:bible_feed/service/haptic_availability_service.dart' as _i729;
import 'package:bible_feed/service/haptic_service.dart' as _i22;
import 'package:bible_feed/service/haptic_toggler_service.dart' as _i513;
import 'package:bible_feed/service/haptic_wireup_service.dart' as _i969;
import 'package:bible_feed/service/platform_service.dart' as _i578;
import 'package:bible_feed/service/verse_scope_service.dart' as _i109;
import 'package:bible_feed/service/verse_scope_toggler_service.dart' as _i430;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'injectable.dart' as _i1027;
import 'test_data.dart' as _i505;

const String _test = 'test';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModuleTest = _$RegisterModuleTest();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModuleTest.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i1033.BookListWheelState>(
      () => _i1033.BookListWheelState(),
    );
    gh.lazySingleton<_i1033.ChapterListWheelState>(
      () => _i1033.ChapterListWheelState(),
    );
    gh.lazySingleton<_i967.VerseScopes>(() => _i967.VerseScopes());
    gh.lazySingleton<_i229.BibleReaderAppInstallService>(
      () => _i229.BibleReaderAppInstallService(),
    );
    gh.lazySingleton<_i438.ProductionReadingLists>(
      () => _i438.ProductionReadingLists(),
    );
    gh.lazySingleton<_i578.PlatformService>(
      () => _i505.TestPlatformService(),
      registerFor: {_test},
    );
    gh.lazySingleton<_i1070.BibleReaders>(
      () => const _i545.ProductionBibleReaders(),
    );
    gh.lazySingleton<_i119.FeedStoreService>(
      () => _i119.FeedStoreService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i578.PlatformService>(
      () => _i578.ProdPlatformService(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i430.VerseScopeTogglerService>(
      () => _i430.VerseScopeTogglerService(gh<_i460.SharedPreferences>()),
    );
    await gh.lazySingletonAsync<_i729.HapticAvailabilityService>(
      () => _i729.HapticAvailabilityService.create(),
      registerFor: {_prod},
      preResolve: true,
    );
    gh.lazySingleton<_i283.BibleReaderService>(
      () => _i283.BibleReaderService(
        gh<_i229.BibleReaderAppInstallService>(),
        gh<_i460.SharedPreferences>(),
        gh<_i1070.BibleReaders>(),
      ),
    );
    gh.lazySingleton<_i513.HapticTogglerService>(
      () => _i513.HapticTogglerService(
        gh<_i460.SharedPreferences>(),
        gh<_i729.HapticAvailabilityService>(),
      ),
    );
    gh.lazySingleton<_i109.VerseScopeService>(
      () => _i109.VerseScopeService(
        gh<_i967.VerseScopes>(),
        gh<_i430.VerseScopeTogglerService>(),
      ),
    );
    gh.lazySingleton<_i759.Feeds>(
      () => _i759.Feeds(
        gh<_i119.FeedStoreService>(),
        gh<_i109.VerseScopeService>(),
        gh<_i438.ProductionReadingLists>(),
      ),
    );
    gh.lazySingleton<_i22.HapticService>(
      () => _i22.HapticService(gh<_i513.HapticTogglerService>()),
    );
    gh.lazySingleton<_i307.FeedsAdvanceService>(
      () => _i307.FeedsAdvanceService(
        gh<_i460.SharedPreferences>(),
        gh<_i759.Feeds>(),
      ),
    );
    gh.singleton<_i969.HapticWireupService>(
      () => _i969.HapticWireupService(
        gh<_i22.HapticService>(),
        gh<_i513.HapticTogglerService>(),
        gh<_i283.BibleReaderService>(),
        gh<_i1033.BookListWheelState>(),
        gh<_i1033.ChapterListWheelState>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i136.AllDoneDialogService>(
      () => _i136.AllDoneDialogService(
        gh<_i307.FeedsAdvanceService>(),
        gh<_i759.Feeds>(),
      ),
    );
    gh.singleton<_i148.AutoAdvanceService>(
      () => _i148.AutoAdvanceService(gh<_i307.FeedsAdvanceService>()),
      registerFor: {_prod},
    );
    return this;
  }
}

class _$RegisterModuleTest extends _i1027.RegisterModuleTest {}
