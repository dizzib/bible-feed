import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'all_done_manager.dart';
import 'feeds_advance_manager.dart';
import 'midnight_manager.dart';

@lazySingleton
class CatchupManager with ChangeNotifier {
  final AllDoneManager _allDoneManager;
  final DateTimeService _dateTimeService;
  final FeedsAdvanceManager _feedsAdvanceManager;
  final MidnightManager _midnightManager;
  final StoreService _storeService;

  CatchupManager(
    this._allDoneManager,
    this._dateTimeService,
    this._feedsAdvanceManager,
    this._midnightManager,
    this._storeService,
  ) {
    AppLifecycleListener(onResume: notifyListeners);

    if (virtualAllDoneDate == null) {
      _save(_dateTimeService.now - const Duration(days: 1));
    }

    _feedsAdvanceManager.addListener(() {
      _save(daysBehind > 0 ? virtualAllDoneDate! + const Duration(days: 1) : _allDoneManager.allDoneDate);
    });

    _midnightManager.addListener(notifyListeners);

    notifyListeners();
  }

  static const _virtualAllDoneDateStoreKey = 'virtualAllDoneDate';

  void _save(DateTime value) => _storeService.setDateTime(_virtualAllDoneDateStoreKey, value);

  DateTime? get virtualAllDoneDate => _storeService.getDateTime(_virtualAllDoneDateStoreKey);

  int get daysBehind {
    final now = _dateTimeService.now;
    final midnightThisMorning = DateTime(now.year, now.month, now.day);
    final midnightVirtualAllDone = DateTime(
      virtualAllDoneDate!.year,
      virtualAllDoneDate!.month,
      virtualAllDoneDate!.day,
    );
    Log.info(midnightThisMorning);
    Log.info(midnightVirtualAllDone);
    return max(0, midnightThisMorning.difference(midnightVirtualAllDone).inDays - 1);
  }
}
