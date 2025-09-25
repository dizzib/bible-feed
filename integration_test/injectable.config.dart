// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_install_events/app_install_events.dart' as _i96;
import 'package:bible_feed/model/bible_reader.dart' as _i270;
import 'package:bible_feed/model/bible_readers.dart' as _i1070;
import 'package:bible_feed/model/chapter_splitter.dart' as _i19;
import 'package:bible_feed/model/chapter_splitters.dart' as _i1006;
import 'package:bible_feed/model/feeds.dart' as _i759;
import 'package:bible_feed/model/list_wheel_state.dart' as _i1033;
import 'package:bible_feed/model/reading_list.dart' as _i279;
import 'package:bible_feed/model/reading_lists.dart' as _i823;
import 'package:bible_feed/service/all_done_dialog_service.dart' as _i136;
import 'package:bible_feed/service/app_install_service.dart' as _i817;
import 'package:bible_feed/service/app_service.dart' as _i977;
import 'package:bible_feed/service/auto_advance_service.dart' as _i148;
import 'package:bible_feed/service/bible_reader_launch_service.dart' as _i905;
import 'package:bible_feed/service/bible_reader_link_service.dart' as _i134;
import 'package:bible_feed/service/chapter_split_service.dart' as _i283;
import 'package:bible_feed/service/chapter_split_toggler_service.dart' as _i301;
import 'package:bible_feed/service/feed_store_service.dart' as _i119;
import 'package:bible_feed/service/feeds_advance_service.dart' as _i307;
import 'package:bible_feed/service/haptic_service.dart' as _i22;
import 'package:bible_feed/service/haptic_toggler_service.dart' as _i513;
import 'package:bible_feed/service/haptic_wireup_service.dart' as _i969;
import 'package:bible_feed/service/platform_service.dart' as _i578;
import 'package:bible_feed/service/url_launch_service.dart' as _i626;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'injectable.dart' as _i1027;

const String _prod = 'prod';
const String _screenshot = 'screenshot';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final readingListsModule = _$ReadingListsModule();
    final chapterSplittersModule = _$ChapterSplittersModule();
    final bibleReadersModule = _$BibleReadersModule();
    gh.singleton<_i1027.AutoAdvanceService>(() => _i1027.AutoAdvanceService());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.clearedSharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i96.AppIUEvents>(() => registerModule.appIUEvents);
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
    gh.lazySingleton<_i119.FeedStoreService>(
      () => _i119.FeedStoreService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1070.BibleReaders>(
      () => _i1070.BibleReaders(gh<List<_i270.BibleReader>>()),
    );
    gh.lazySingleton<_i1006.ChapterSplitters>(
      () => _i1006.ChapterSplitters(gh<List<_i19.ChapterSplitter>>()),
    );
    await gh.lazySingletonAsync<_i977.AppService>(
      () => _i977.ProductionAppService.create(),
      registerFor: {_prod},
      preResolve: true,
    );
    gh.lazySingleton<_i301.ChapterSplitTogglerService>(
      () => _i301.ChapterSplitTogglerService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i283.ChapterSplitService>(
      () => _i283.ChapterSplitService(
        gh<_i1006.ChapterSplitters>(),
        gh<_i301.ChapterSplitTogglerService>(),
      ),
    );
    await gh.lazySingletonAsync<_i578.PlatformService>(
      () => _i578.ProductionPlatformService.create(),
      registerFor: {_prod},
      preResolve: true,
    );
    gh.lazySingleton<_i817.AppInstallService>(
      () => _i817.AppInstallService(),
      registerFor: {_screenshot},
    );
    gh.lazySingleton<_i578.PlatformService>(
      () => _i578.ScreenshotPlatformService(),
      registerFor: {_screenshot},
    );
    gh.lazySingleton<_i513.HapticTogglerService>(
      () => _i513.HapticTogglerService(
        gh<_i460.SharedPreferences>(),
        gh<_i578.PlatformService>(),
      ),
    );
    gh.lazySingleton<_i905.BibleReaderLaunchService>(
      () => _i905.BibleReaderLaunchService(gh<_i626.UrlLaunchService>()),
    );
    gh.lazySingleton<_i823.ReadingLists>(
      () => _i823.ReadingLists(gh<List<_i279.ReadingList>>()),
    );
    gh.lazySingleton<_i134.BibleReaderLinkService>(
      () => _i134.BibleReaderLinkService(
        gh<_i460.SharedPreferences>(),
        gh<_i578.PlatformService>(),
        gh<_i1070.BibleReaders>(),
      ),
    );
    gh.lazySingleton<_i759.Feeds>(
      () => _i759.Feeds(
        gh<_i119.FeedStoreService>(),
        gh<_i283.ChapterSplitService>(),
        gh<_i823.ReadingLists>(),
      ),
    );
    gh.lazySingleton<_i817.AppInstallService>(
      () => _i817.ProductionAppInstallService(
        gh<_i96.AppIUEvents>(),
        gh<_i134.BibleReaderLinkService>(),
        gh<_i905.BibleReaderLaunchService>(),
        gh<_i578.PlatformService>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i307.FeedsAdvanceService>(
      () => _i307.FeedsAdvanceService(
        gh<_i460.SharedPreferences>(),
        gh<_i759.Feeds>(),
      ),
    );
    gh.lazySingleton<_i22.HapticService>(
      () => _i22.HapticService(gh<_i513.HapticTogglerService>()),
    );
    gh.singleton<_i148.AutoAdvanceService>(
      () => _i148.AutoAdvanceService(gh<_i307.FeedsAdvanceService>()),
    );
    gh.lazySingleton<_i136.AllDoneDialogService>(
      () => _i136.AllDoneDialogService(
        gh<_i307.FeedsAdvanceService>(),
        gh<_i759.Feeds>(),
      ),
    );
    gh.singleton<_i969.HapticWireupService>(
      () => _i969.HapticWireupService(
        gh<_i22.HapticService>(),
        gh<_i513.HapticTogglerService>(),
        gh<_i134.BibleReaderLinkService>(),
        gh<_i1033.BookListWheelState>(),
        gh<_i1033.ChapterListWheelState>(),
      ),
      registerFor: {_prod},
    );
    return this;
  }
}

class _$RegisterModule extends _i1027.RegisterModule {}

class _$ReadingListsModule extends _i823.ReadingListsModule {}

class _$ChapterSplittersModule extends _i1006.ChapterSplittersModule {}

class _$BibleReadersModule extends _i1070.BibleReadersModule {}
