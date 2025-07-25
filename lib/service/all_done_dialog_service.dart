import 'package:watch_it/watch_it.dart';
import '/model/feeds.dart';

class AllDoneDialogService {
  bool _isAlreadyShown = false;

  // auto-show dialog once only
  bool get isAutoShowAllDoneDialog => sl<Feeds>().areChaptersRead && !sl<Feeds>().hasEverAdvanced && !_isAlreadyShown;

  set isAlreadyShown(bool value) => _isAlreadyShown = value;
}
