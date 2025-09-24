import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Environment('screenshot')
@lazySingleton
class AppInstallService with ChangeNotifier {}
