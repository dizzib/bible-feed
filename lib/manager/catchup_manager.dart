import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'app_lifecycle_manager.dart';
import 'catchup_setting_manager.dart';
import 'feeds_advance_manager.dart';
import 'feeds_manager.dart';
import 'midnight_manager.dart';

@lazySingleton
class CatchupManager with ChangeNotifier {
  final AppLifecycleManager _appLifecycleManager;
  final CatchupSettingManager _catchupSettingManager;
  final DateTimeService _dateTimeService;
  final FeedsManager _feedsManager;
  final FeedsAdvanceManager _feedsAdvanceManager;
  final MidnightManager _midnightManager;
  final StoreService _storeService;

  CatchupManager(
    this._appLifecycleManager,
    this._catchupSettingManager,
    this._dateTimeService,
    this._feedsManager,
    this._feedsAdvanceManager,
    this._midnightManager,
    this._storeService,
  ) {
    Log.info('ctor');
    _appLifecycleManager.onResume(notifyListeners);

    _feedsAdvanceManager.addListener(() {
      virtualAllDoneDate = isBehind ? virtualAllDoneDate + 1.days : _dateTimeService.now.date;
    });

    _catchupSettingManager.addListener(() {
      virtualAllDoneDate = _defaultVirtualAllDoneDate;
    });

    _midnightManager.addListener(notifyListeners);

    virtualAllDoneDate = virtualAllDoneDate; // ensure default is stored
  }

  static const _storeKey = 'virtualAllDoneDate';

  DateTime get _defaultVirtualAllDoneDate => _dateTimeService.now.date - 1.days;

  //// public

  int get chaptersToRead => daysBehind * _feedsManager.feeds.length + _feedsManager.chaptersToRead;

  int get daysBehind {
    if (!_catchupSettingManager.isEnabled) return 0;
    return max(0, _dateTimeService.now.date.difference(virtualAllDoneDate).inDays - 1);
  }

  int get daysBehindClamped {
    final upperLimit = 2;
    return daysBehind.clamp(0, upperLimit);
  }

  bool get isBehind => daysBehind > 0;

  bool get isVeryBehind => daysBehind > 1;

  DateTime get virtualAllDoneDate => _storeService.getDateTime(_storeKey) ?? _defaultVirtualAllDoneDate;

  set virtualAllDoneDate(DateTime value) {
    _storeService.setDateTime(_storeKey, value);
    notifyListeners();
  }
}
