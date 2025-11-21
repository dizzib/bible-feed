import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../service/date_time_service.dart';
import '../service/store_service.dart';
import 'feeds_manager.dart';

@lazySingleton
class AllDoneManager with ChangeNotifier {
  final DateTimeService _dateTimeService;
  final FeedsManager _feedsManager;
  final StoreService _storeService;

  AllDoneManager(this._dateTimeService, this._feedsManager, this._storeService) {
    _feedsManager.addListener(() {
      if (_feedsManager.areChaptersRead) {
        _storeService.setDateTime(_allDoneDateStoreKey, _dateTimeService.now);
        notifyListeners();
      }
    });
  }

  static const _allDoneDateStoreKey = 'allDoneDate';

  DateTime get allDoneDate => _storeService.getDateTime(_allDoneDateStoreKey) ?? _dateTimeService.now - 1.days;
}
