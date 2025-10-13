// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bible_feed/injectable.dart' as _i537;
import 'package:bible_feed/manager/all_done_dialog_manager.dart' as _i541;
import 'package:bible_feed/manager/app_install_manager.dart' as _i610;
import 'package:bible_feed/manager/auto_advance_manager.dart' as _i111;
import 'package:bible_feed/manager/bible_reader_launch_manager.dart' as _i186;
import 'package:bible_feed/manager/bible_reader_link_manager.dart' as _i567;
import 'package:bible_feed/manager/bible_readers_certified_manager.dart'
    as _i837;
import 'package:bible_feed/manager/chapter_split_manager.dart' as _i10;
import 'package:bible_feed/manager/chapter_split_toggler_manager.dart' as _i172;
import 'package:bible_feed/manager/feed_advance_manager.dart' as _i716;
import 'package:bible_feed/manager/feed_store_manager.dart' as _i571;
import 'package:bible_feed/manager/feeds_advance_manager.dart' as _i477;
import 'package:bible_feed/manager/feeds_manager.dart' as _i127;
import 'package:bible_feed/manager/haptic_toggler_manager.dart' as _i79;
import 'package:bible_feed/manager/haptic_wireup_manager.dart' as _i519;
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
import 'package:bible_feed/service/platform_event_service.dart' as _i516;
import 'package:bible_feed/service/platform_service.dart' as _i578;
import 'package:bible_feed/service/url_launch_service.dart' as _i626;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

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
    final registerThirdParty = _$RegisterThirdParty();
    final readingListsModule = _$ReadingListsModule();
    final chapterSplittersModule = _$ChapterSplittersModule();
    final bibleReadersModule = _$BibleReadersModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerThirdParty.sharedPreferences,
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
    gh.lazySingleton<_i571.FeedStoreManager>(
      () => _i571.FeedStoreManager(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1070.BibleReaders>(
      () => _i1070.BibleReaders(gh<List<_i270.BibleReader>>()),
    );
    gh.lazySingleton<_i1006.ChapterSplitters>(
      () => _i1006.ChapterSplitters(gh<List<_i19.ChapterSplitter>>()),
    );
    gh.lazySingleton<_i837.BibleReadersCertifiedManager>(
      () => _i837.BibleReadersCertifiedManager(
        gh<_i578.PlatformService>(),
        gh<_i1070.BibleReaders>(),
      ),
    );
    gh.lazySingleton<_i172.ChapterSplitTogglerManager>(
      () => _i172.ChapterSplitTogglerManager(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i186.BibleReaderLaunchManager>(
      () => _i186.BibleReaderLaunchManager(
        gh<_i578.PlatformService>(),
        gh<_i626.UrlLaunchService>(),
      ),
    );
    gh.lazySingleton<_i79.HapticTogglerManager>(
      () => _i79.HapticTogglerManager(
        gh<_i460.SharedPreferences>(),
        gh<_i578.PlatformService>(),
      ),
    );
    gh.lazySingleton<_i823.ReadingLists>(
      () => _i823.ReadingLists(gh<List<_i279.ReadingList>>()),
    );
    gh.lazySingleton<_i516.PlatformEventService>(
      () => _i516.ProductionPlatformEventService(gh<_i578.PlatformService>()),
      registerFor: {_midnight_test, _prod},
    );
    gh.lazySingleton<_i567.BibleReaderLinkManager>(
      () => _i567.BibleReaderLinkManager(
        gh<_i460.SharedPreferences>(),
        gh<_i837.BibleReadersCertifiedManager>(),
      ),
    );
    gh.lazySingleton<_i10.ChapterSplitManager>(
      () => _i10.ChapterSplitManager(
        gh<_i1006.ChapterSplitters>(),
        gh<_i172.ChapterSplitTogglerManager>(),
      ),
    );
    gh.lazySingleton<_i716.FeedAdvanceManager>(
      () => _i716.FeedAdvanceManager(gh<_i10.ChapterSplitManager>()),
    );
    gh.lazySingleton<_i127.FeedsManager>(
      () => _i127.FeedsManager(
        gh<_i571.FeedStoreManager>(),
        gh<_i823.ReadingLists>(),
      ),
    );
    gh.lazySingleton<_i477.FeedsAdvanceManager>(
      () => _i477.FeedsAdvanceManager(
        gh<_i99.DateTimeService>(),
        gh<_i460.SharedPreferences>(),
        gh<_i716.FeedAdvanceManager>(),
        gh<_i127.FeedsManager>(),
      ),
    );
    gh.lazySingleton<_i22.HapticService>(
      () => _i22.HapticService(gh<_i79.HapticTogglerManager>()),
    );
    gh.singleton<_i519.HapticWireupManager>(
      () => _i519.HapticWireupManager(
        gh<_i22.HapticService>(),
        gh<_i172.ChapterSplitTogglerManager>(),
        gh<_i79.HapticTogglerManager>(),
        gh<_i567.BibleReaderLinkManager>(),
        gh<_i1033.BookListWheelState>(),
        gh<_i1033.ChapterListWheelState>(),
      ),
    );
    gh.lazySingleton<_i610.AppInstallManager>(
      () => _i610.AppInstallManager(
        gh<_i186.BibleReaderLaunchManager>(),
        gh<_i567.BibleReaderLinkManager>(),
        gh<_i516.PlatformEventService>(),
      ),
    );
    gh.singleton<_i111.AutoAdvanceManager>(
      () => _i111.AutoAdvanceManager(
        gh<_i99.DateTimeService>(),
        gh<_i477.FeedsAdvanceManager>(),
      ),
    );
    gh.lazySingleton<_i541.AllDoneDialogManager>(
      () => _i541.AllDoneDialogManager(
        gh<_i477.FeedsAdvanceManager>(),
        gh<_i127.FeedsManager>(),
      ),
    );
    return this;
  }
}

class _$RegisterThirdParty extends _i537.RegisterThirdParty {}

class _$ReadingListsModule extends _i823.ReadingListsModule {}

class _$ChapterSplittersModule extends _i1006.ChapterSplittersModule {}

class _$BibleReadersModule extends _i1070.BibleReadersModule {}
