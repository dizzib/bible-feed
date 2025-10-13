// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bible_feed/manager/haptic_toggler_service.dart' as _i524;
import 'package:bible_feed/manager/platform_event_service.dart' as _i137;
import 'package:bible_feed/model/bible_reader.dart' as _i270;
import 'package:bible_feed/model/bible_readers.dart' as _i1070;
import 'package:bible_feed/model/chapter_splitter.dart' as _i19;
import 'package:bible_feed/model/chapter_splitters.dart' as _i1006;
import 'package:bible_feed/model/list_wheel_state.dart' as _i1033;
import 'package:bible_feed/model/reading_list.dart' as _i279;
import 'package:bible_feed/model/reading_lists.dart' as _i823;
import 'package:bible_feed/service/app_service.dart' as _i977;
import 'package:bible_feed/service/date_time_service.dart' as _i99;
import 'package:bible_feed/service/haptic_service.dart' as _i22;
import 'package:bible_feed/service/platform_service.dart' as _i578;
import 'package:bible_feed/service/url_launch_service.dart' as _i626;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'golden/stub/stub_app_service.dart' as _i252;
import 'golden/stub/stub_platform_event_service.dart' as _i919;
import 'golden/stub/stub_platform_service.dart' as _i250;
import 'injectable.dart' as _i1027;

const String _golden = 'golden';
const String _prod = 'prod';
const String _midnight_test = 'midnight_test';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModuleTest = _$RegisterModuleTest();
    final readingListsModule = _$ReadingListsModule();
    final chapterSplittersModule = _$ChapterSplittersModule();
    final bibleReadersModule = _$BibleReadersModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModuleTest.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i1033.BookListWheelState>(
      () => _i1033.BookListWheelState(),
    );
    gh.lazySingleton<_i1033.ChapterListWheelState>(
      () => _i1033.ChapterListWheelState(),
    );
    gh.lazySingleton<List<_i279.ReadingList>>(
      () => readingListsModule.readingLists,
    );
    gh.lazySingleton<List<_i19.ChapterSplitter>>(
      () => chapterSplittersModule.chapterSplitters,
    );
    gh.lazySingleton<List<_i270.BibleReader>>(
      () => bibleReadersModule.bibleReader,
    );
    gh.lazySingleton<_i626.UrlLaunchService>(() => _i626.UrlLaunchService());
    gh.lazySingleton<_i99.DateTimeService>(
      () => _i99.NowDateTimeService(),
      registerFor: {_golden, _prod},
    );
    await gh.lazySingletonAsync<_i977.AppService>(
      () => _i977.ProductionAppService.create(),
      registerFor: {_midnight_test, _prod},
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i578.PlatformService>(
      () => _i578.ProductionPlatformService.create(),
      registerFor: {_midnight_test, _prod},
      preResolve: true,
    );
    gh.lazySingleton<_i1070.BibleReaders>(
      () => _i1070.BibleReaders(gh<List<_i270.BibleReader>>()),
    );
    gh.lazySingleton<_i1006.ChapterSplitters>(
      () => _i1006.ChapterSplitters(gh<List<_i19.ChapterSplitter>>()),
    );
    await gh.lazySingletonAsync<_i977.AppService>(
      () => _i252.ScreenshotAppService.create(),
      registerFor: {_golden},
      preResolve: true,
    );
    gh.lazySingleton<_i578.PlatformService>(
      () => _i250.ScreenshotPlatformService(),
      registerFor: {_golden},
    );
    gh.lazySingleton<_i137.PlatformEventService>(
      () => _i919.ScreenshotPlatformEventService(),
      registerFor: {_golden},
    );
    gh.lazySingleton<_i22.HapticService>(
      () => _i22.HapticService(gh<_i524.HapticTogglerService>()),
    );
    gh.lazySingleton<_i823.ReadingLists>(
      () => _i823.ReadingLists(gh<List<_i279.ReadingList>>()),
    );
    return this;
  }
}

class _$RegisterModuleTest extends _i1027.RegisterModuleTest {}

class _$ReadingListsModule extends _i823.ReadingListsModule {}

class _$ChapterSplittersModule extends _i1006.ChapterSplittersModule {}

class _$BibleReadersModule extends _i1070.BibleReadersModule {}
