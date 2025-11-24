// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bible_feed/manager/all_done_dialog_manager.dart' as _i541;
import 'package:bible_feed/manager/app_install_manager.dart' as _i610;
import 'package:bible_feed/manager/auto_advance_manager.dart' as _i111;
import 'package:bible_feed/manager/bible_reader_launch_manager.dart' as _i186;
import 'package:bible_feed/manager/bible_reader_link_manager.dart' as _i567;
import 'package:bible_feed/manager/bible_readers_certified_manager.dart'
    as _i837;
import 'package:bible_feed/manager/catchup_dialog_manager.dart' as _i156;
import 'package:bible_feed/manager/catchup_manager.dart' as _i1045;
import 'package:bible_feed/manager/catchup_setting_manager.dart' as _i282;
import 'package:bible_feed/manager/chapter_split_manager.dart' as _i10;
import 'package:bible_feed/manager/chapter_split_setting_manager.dart' as _i632;
import 'package:bible_feed/manager/deeplink_in_manager.dart' as _i468;
import 'package:bible_feed/manager/deeplink_out_manager.dart' as _i768;
import 'package:bible_feed/manager/feed_advance_manager.dart' as _i716;
import 'package:bible_feed/manager/feed_store_manager.dart' as _i571;
import 'package:bible_feed/manager/feed_tap_manager.dart' as _i583;
import 'package:bible_feed/manager/feeds_advance_manager.dart' as _i477;
import 'package:bible_feed/manager/feeds_manager.dart' as _i127;
import 'package:bible_feed/manager/haptic_setting_manager.dart' as _i274;
import 'package:bible_feed/manager/haptic_wireup_manager.dart' as _i519;
import 'package:bible_feed/manager/json_encoding_manager.dart' as _i508;
import 'package:bible_feed/manager/midnight_manager.dart' as _i438;
import 'package:bible_feed/manager/share_in_manager.dart' as _i864;
import 'package:bible_feed/manager/share_out_manager.dart' as _i175;
import 'package:bible_feed/model/bible_reader.dart' as _i270;
import 'package:bible_feed/model/bible_readers.dart' as _i1070;
import 'package:bible_feed/model/chapter_splitter.dart' as _i19;
import 'package:bible_feed/model/chapter_splitters.dart' as _i1006;
import 'package:bible_feed/model/list_wheel_state.dart' as _i1033;
import 'package:bible_feed/model/reading_list.dart' as _i279;
import 'package:bible_feed/model/reading_lists.dart' as _i823;
import 'package:bible_feed/service/app_service.dart' as _i977;
import 'package:bible_feed/service/date_time_service.dart' as _i99;
import 'package:bible_feed/service/deeplink_service.dart' as _i326;
import 'package:bible_feed/service/haptic_availability_service.dart' as _i729;
import 'package:bible_feed/service/haptic_service.dart' as _i22;
import 'package:bible_feed/service/platform_event_service.dart' as _i516;
import 'package:bible_feed/service/platform_service.dart' as _i578;
import 'package:bible_feed/service/store_service.dart' as _i215;
import 'package:bible_feed/service/toast_service.dart' as _i942;
import 'package:bible_feed/service/url_launch_service.dart' as _i626;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

const String _golden = 'golden';
const String _prod = 'prod';
const String _integration_test = 'integration_test';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final readingListsModule = _$ReadingListsModule();
    final chapterSplittersModule = _$ChapterSplittersModule();
    final bibleReadersModule = _$BibleReadersModule();
    gh.lazySingleton<_i508.JsonEncodingManager>(
      () => _i508.JsonEncodingManager(),
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
    gh.lazySingleton<_i942.ToastService>(() => _i942.ToastService());
    gh.lazySingleton<_i99.DateTimeService>(
      () => _i99.NowDateTimeService(),
      registerFor: {_golden, _prod},
    );
    await gh.lazySingletonAsync<_i215.StoreService>(
      () => _i215.StoreService.create(),
      registerFor: {_golden, _prod},
      preResolve: true,
    );
    gh.lazySingleton<_i632.ChapterSplitSettingManager>(
      () => _i632.ChapterSplitSettingManager(gh<_i215.StoreService>()),
    );
    gh.lazySingleton<_i282.CatchupSettingManager>(
      () => _i282.CatchupSettingManager(gh<_i215.StoreService>()),
    );
    gh.lazySingleton<_i1070.BibleReaders>(
      () => _i1070.BibleReaders(gh<List<_i270.BibleReader>>()),
    );
    gh.lazySingleton<_i1006.ChapterSplitters>(
      () => _i1006.ChapterSplitters(gh<List<_i19.ChapterSplitter>>()),
    );
    gh.lazySingleton<_i10.ChapterSplitManager>(
      () => _i10.ChapterSplitManager(
        gh<_i1006.ChapterSplitters>(),
        gh<_i632.ChapterSplitSettingManager>(),
      ),
    );
    gh.lazySingleton<_i326.DeepLinkService>(
      () => _i326.DeepLinkService(gh<_i942.ToastService>()),
    );
    await gh.lazySingletonAsync<_i729.HapticAvailabilityService>(
      () => _i729.ProductionHapticAvailabilityService.create(),
      registerFor: {_integration_test, _prod},
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i977.AppService>(
      () => _i977.ProductionAppService.create(),
      registerFor: {_integration_test, _prod},
      preResolve: true,
    );
    gh.singleton<_i438.MidnightManager>(
      () => _i438.ProdMidnightManager(gh<_i99.DateTimeService>()),
      registerFor: {_golden, _prod},
    );
    gh.lazySingleton<_i823.ReadingLists>(
      () => _i823.ReadingLists(gh<List<_i279.ReadingList>>()),
    );
    gh.lazySingleton<_i274.HapticSettingManager>(
      () => _i274.HapticSettingManager(
        gh<_i215.StoreService>(),
        gh<_i729.HapticAvailabilityService>(),
      ),
    );
    gh.lazySingleton<_i571.FeedStoreManager>(
      () => _i571.FeedStoreManager(gh<_i215.StoreService>()),
    );
    gh.lazySingleton<_i578.PlatformService>(
      () => _i578.ProductionPlatformService(),
      registerFor: {_integration_test, _prod},
    );
    gh.lazySingleton<_i22.HapticService>(
      () => _i22.HapticService(gh<_i274.HapticSettingManager>()),
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
    gh.lazySingleton<_i516.PlatformEventService>(
      () => _i516.ProductionPlatformEventService(gh<_i578.PlatformService>()),
      registerFor: {_integration_test, _prod},
    );
    gh.lazySingleton<_i837.BibleReadersCertifiedManager>(
      () => _i837.BibleReadersCertifiedManager(
        gh<_i578.PlatformService>(),
        gh<_i1070.BibleReaders>(),
      ),
    );
    gh.lazySingleton<_i186.BibleReaderLaunchManager>(
      () => _i186.BibleReaderLaunchManager(
        gh<_i578.PlatformService>(),
        gh<_i626.UrlLaunchService>(),
      ),
    );
    gh.lazySingleton<_i864.ShareInManager>(
      () => _i864.ShareInManager(
        gh<_i977.AppService>(),
        gh<_i127.FeedsManager>(),
      ),
    );
    gh.lazySingleton<_i175.ShareOutManager>(
      () => _i175.ShareOutManager(
        gh<_i977.AppService>(),
        gh<_i127.FeedsManager>(),
      ),
    );
    gh.lazySingleton<_i567.BibleReaderLinkManager>(
      () => _i567.BibleReaderLinkManager(
        gh<_i215.StoreService>(),
        gh<_i837.BibleReadersCertifiedManager>(),
      ),
    );
    gh.singleton<_i468.DeepLinkInManager>(
      () => _i468.DeepLinkInManager(
        gh<_i326.DeepLinkService>(),
        gh<_i508.JsonEncodingManager>(),
        gh<_i864.ShareInManager>(),
        gh<_i942.ToastService>(),
      ),
    );
    gh.lazySingleton<_i610.AppInstallManager>(
      () => _i610.AppInstallManager(
        gh<_i186.BibleReaderLaunchManager>(),
        gh<_i567.BibleReaderLinkManager>(),
        gh<_i516.PlatformEventService>(),
      ),
    );
    gh.lazySingleton<_i541.AllDoneDialogManager>(
      () => _i541.AllDoneDialogManager(
        gh<_i215.StoreService>(),
        gh<_i127.FeedsManager>(),
      ),
    );
    gh.lazySingleton<_i477.FeedsAdvanceManager>(
      () => _i477.FeedsAdvanceManager(
        gh<_i99.DateTimeService>(),
        gh<_i716.FeedAdvanceManager>(),
        gh<_i127.FeedsManager>(),
        gh<_i215.StoreService>(),
      ),
    );
    gh.singleton<_i519.HapticWireupManager>(
      () => _i519.HapticWireupManager(
        gh<_i22.HapticService>(),
        gh<_i632.ChapterSplitSettingManager>(),
        gh<_i274.HapticSettingManager>(),
        gh<_i567.BibleReaderLinkManager>(),
        gh<_i1033.BookListWheelState>(),
        gh<_i1033.ChapterListWheelState>(),
      ),
    );
    gh.lazySingleton<_i583.FeedTapManager>(
      () => _i583.FeedTapManager(
        gh<_i186.BibleReaderLaunchManager>(),
        gh<_i567.BibleReaderLinkManager>(),
        gh<_i22.HapticService>(),
      ),
    );
    gh.singleton<_i768.DeepLinkOutManager>(
      () => _i768.DeepLinkOutManager(
        gh<_i508.JsonEncodingManager>(),
        gh<_i175.ShareOutManager>(),
      ),
    );
    gh.lazySingleton<_i111.AutoAdvanceManager>(
      () => _i111.AutoAdvanceManager(
        gh<_i477.FeedsAdvanceManager>(),
        gh<_i438.MidnightManager>(),
      ),
    );
    gh.lazySingleton<_i1045.CatchupManager>(
      () => _i1045.CatchupManager(
        gh<_i282.CatchupSettingManager>(),
        gh<_i99.DateTimeService>(),
        gh<_i477.FeedsAdvanceManager>(),
        gh<_i438.MidnightManager>(),
        gh<_i215.StoreService>(),
      ),
    );
    gh.lazySingleton<_i156.CatchupDialogManager>(
      () => _i156.CatchupDialogManager(
        gh<_i215.StoreService>(),
        gh<_i1045.CatchupManager>(),
        gh<_i127.FeedsManager>(),
      ),
    );
    return this;
  }
}

class _$ReadingListsModule extends _i823.ReadingListsModule {}

class _$ChapterSplittersModule extends _i1006.ChapterSplittersModule {}

class _$BibleReadersModule extends _i1070.BibleReadersModule {}
