import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'catchup_setting_manager.dart';
import 'feeds_advance_manager.dart';
import 'midnight_manager.dart';

@lazySingleton
class CatchupManager with ChangeNotifier {
  final CatchupSettingManager _catchupSettingManager;
  final DateTimeService _dateTimeService;
  final FeedsAdvanceManager _feedsAdvanceManager;
  final MidnightManager _midnightManager;
  final StoreService _storeService;

  CatchupManager(
    this._catchupSettingManager,
    this._dateTimeService,
    this._feedsAdvanceManager,
    this._midnightManager,
    this._storeService,
  ) {
    AppLifecycleListener(onResume: notifyListeners);

    _feedsAdvanceManager.addListener(() {
      _save(isBehind ? _virtualAllDoneDate + 1.days : _dateTimeService.now.date);
      notifyListeners();
    });

    _catchupSettingManager.addListener(() {
      _save(_defaultVirtualAllDoneDate);
      notifyListeners();
    });

    _midnightManager.addListener(notifyListeners);

    _save(_virtualAllDoneDate); // ensure saved to store the first time app is run
    notifyListeners();
  }

  static const _virtualAllDoneDateStoreKey = 'virtualAllDoneDate';

  DateTime get _defaultVirtualAllDoneDate => _dateTimeService.now.date - 1.days;
  DateTime get _virtualAllDoneDate =>
      _storeService.getDateTime(_virtualAllDoneDateStoreKey) ?? _defaultVirtualAllDoneDate;

  void _save(DateTime value) => _storeService.setDateTime(_virtualAllDoneDateStoreKey, value);

  int get daysBehind {
    if (!_catchupSettingManager.isEnabled) return 0;
    return max(0, _dateTimeService.now.date.difference(_virtualAllDoneDate).inDays - 1);
  }

  bool get isBehind => daysBehind > 0;
  bool get isVeryBehind => daysBehind > 1;
}
