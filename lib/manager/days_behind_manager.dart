import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'all_done_manager.dart';
import 'feeds_advance_manager.dart';

@lazySingleton
class DaysBehindManager with ChangeNotifier {
  final AllDoneManager _allDoneManager;
  final DateTimeService _dateTimeService;
  final FeedsAdvanceManager _feedsAdvanceManager;
  final StoreService _storeService;

  DaysBehindManager(this._allDoneManager, this._dateTimeService, this._feedsAdvanceManager, this._storeService) {
    _feedsAdvanceManager.addListener(() {
      _storeService.setDateTime(
        _virtualAllDoneDateStoreKey,
        daysBehind > 0 ? virtualAllDoneDate + const Duration(days: 1) : _allDoneManager.allDoneDate,
      );
      notifyListeners();
    });
  }

  static const _virtualAllDoneDateStoreKey = 'virtualAllDoneDate';

  DateTime get virtualAllDoneDate =>
      _storeService.getDateTime(_virtualAllDoneDateStoreKey) ?? _dateTimeService.now - const Duration(days: 1);

  int get daysBehind {
    final now = _dateTimeService.now;
    final midnightThisMorning = DateTime(now.year, now.month, now.day);
    final midnightVirtualAllDone = DateTime(virtualAllDoneDate.year, virtualAllDoneDate.month, virtualAllDoneDate.day);
    return max(0, midnightThisMorning.difference(midnightVirtualAllDone).inDays - 1);
  }
}
