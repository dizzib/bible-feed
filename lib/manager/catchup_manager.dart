import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'all_done_manager.dart';
import 'midnight_manager.dart';

@lazySingleton
class CatchupManager with ChangeNotifier {
  final AllDoneManager _allDoneManager;
  final DateTimeService _dateTimeService;
  final MidnightManager _midnightManager;
  final StoreService _storeService;

  CatchupManager(this._allDoneManager, this._dateTimeService, this._midnightManager, this._storeService) {
    AppLifecycleListener(onResume: notifyListeners);

    if (_virtualAllDoneDate == null) {
      _save(_dateTimeService.now - 1.days);
    }

    _allDoneManager.addListener(() {
      _save(daysBehind > 0 ? _virtualAllDoneDate! + 1.days : _allDoneManager.allDoneDate);
      notifyListeners();
    });

    _midnightManager.addListener(notifyListeners);

    notifyListeners();
  }

  static const _virtualAllDoneDateStoreKey = 'virtualAllDoneDate';

  void _save(DateTime value) => _storeService.setDateTime(_virtualAllDoneDateStoreKey, value);

  DateTime? get _virtualAllDoneDate => _storeService.getDateTime(_virtualAllDoneDateStoreKey);
  int get daysBehind => max(0, _dateTimeService.now.date.difference(_virtualAllDoneDate!.date).inDays - 1);
  bool get isBehind => daysBehind > 0;
}
