import 'package:injectable/injectable.dart';

import '/model/feeds.dart';

@lazySingleton
class AllDoneDialogService {
  final Feeds feeds;

  AllDoneDialogService(this.feeds);

  bool _isAlreadyShown = false;

  // auto-show dialog once only
  bool get isAutoShowAllDoneDialog => feeds.areChaptersRead && !feeds.hasEverAdvanced && !_isAlreadyShown;

  set isAlreadyShown(bool value) => _isAlreadyShown = value;
}
